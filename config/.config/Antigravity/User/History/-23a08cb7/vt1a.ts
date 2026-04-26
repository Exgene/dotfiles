import { NextResponse } from "next/server";
import { createWalletClient, createPublicClient, http, parseAbi } from "viem";
import { polygon } from "viem/chains";
import { privateKeyToAccount } from "viem/accounts";
import { ClobClient, AssetType } from "@polymarket/clob-client-v2";

export async function POST() {
  const PRIVATE_KEY = process.env.POLYMARKET_PRIVATE_KEY;
  if (!PRIVATE_KEY) {
    return NextResponse.json({
      error: "POLYMARKET_FUNDER_PRIVATE_KEY is missing in your .env! You MUST provide the private key for 0xE3d5... to convert its funds."
    }, { status: 400 });
  }

  try {
    const account = privateKeyToAccount(PRIVATE_KEY.startsWith("0x") ? PRIVATE_KEY as any : `0x${PRIVATE_KEY}`);
    const publicClient = createPublicClient({ chain: polygon, transport: http() });
    const walletClient = createWalletClient({ account, chain: polygon, transport: http() });

    const ONRAMP_ADDRESS = "0x93070a847efEf7F70739046A929D47a521F5B8ee" as const;
    const USDCE_ADDRESS = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174" as const;

    const erc20Abi = parseAbi([
      "function balanceOf(address) view returns (uint256)",
      "function approve(address spender, uint256 amount) returns (bool)",
    ]);

    const onrampAbi = parseAbi([
      "function wrap(address _asset, address _to, uint256 _amount) external",
    ]);

    // 1. Fetch balance
    const usdcBalance = await publicClient.readContract({
      address: USDCE_ADDRESS,
      abi: erc20Abi,
      functionName: "balanceOf",
      args: [account.address],
    });

    if (usdcBalance === 0n) {
      return NextResponse.json({ status: "0 USDC.e found in wallet. Nothing to wrap." });
    }

    // 2. Approve
    const approveHash = await walletClient.writeContract({
      address: USDCE_ADDRESS,
      abi: erc20Abi,
      functionName: "approve",
      args: [ONRAMP_ADDRESS, usdcBalance],
    });
    await publicClient.waitForTransactionReceipt({ hash: approveHash });

    // 3. Wrap
    const wrapHash = await walletClient.writeContract({
      address: ONRAMP_ADDRESS,
      abi: onrampAbi,
      functionName: "wrap",
      args: [USDCE_ADDRESS, account.address, usdcBalance],
    });
    await publicClient.waitForTransactionReceipt({ hash: wrapHash });

    // 4. Update V2 Exchange API Allowance
    const l1Client = new ClobClient({ host: "https://clob-v2.polymarket.com", chain: 137, signer: walletClient });
    const creds = await l1Client.createOrDeriveApiKey();
    const clobClient = new ClobClient({ host: "https://clob-v2.polymarket.com", chain: 137, signer: walletClient, creds });
    await clobClient.updateBalanceAllowance({ asset_type: AssetType.COLLATERAL });

    return NextResponse.json({ success: true, message: "Successfully wrapped and setup V2 allowance." });
  } catch (err) {
    return NextResponse.json({ error: String(err) }, { status: 500 });
  }
}
