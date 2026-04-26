import { createWalletClient, createPublicClient, http, parseAbi, parseUnits } from "viem";
import { polygon } from "viem/chains";
import { privateKeyToAccount } from "viem/accounts";
import { ClobClient, AssetType } from "@polymarket/clob-client-v2";

const PRIVATE_KEY = process.env.POLYMARKET_PRIVATE_KEY;
const CLOB_HOST = "https://clob-v2.polymarket.com";
const POLYGON_CHAIN_ID = 137;

// Contract Addresses
const ONRAMP_ADDRESS = "0x93070a847efEf7F70739046A929D47a521F5B8ee" as const;
const USDCE_ADDRESS = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174" as const;

// Token ABIs
const erc20Abi = parseAbi([
  "function balanceOf(address) view returns (uint256)",
  "function approve(address spender, uint256 amount) returns (bool)",
]);

const onrampAbi = parseAbi([
  "function wrap(address _asset, address _to, uint256 _amount) external",
]);

async function run() {
  const action = process.argv[2];

  if (!["wrap", "unwrap"].includes(action)) {
    console.error("Usage: npx tsx scripts/manage-collateral.ts [wrap|unwrap]");
    process.exit(1);
  }

  if (!PRIVATE_KEY) {
    console.error(
      "ERROR: POLYMARKET_FUNDER_PRIVATE_KEY is missing in your .env!\n" +
      "This script must run as the Funder (who actually holds the funds), not the API proxy signer."
    );
    process.exit(1);
  }

  const account = privateKeyToAccount(PRIVATE_KEY.startsWith("0x") ? PRIVATE_KEY as any : `0x${PRIVATE_KEY}`);
  const publicClient = createPublicClient({ chain: polygon, transport: http() });
  const walletClient = createWalletClient({ account, chain: polygon, transport: http() });

  console.log(`\n=> Operating as Funder: ${account.address}`);

  if (action === "wrap") {
    // 1. Fetch balance
    const usdcBalance = await publicClient.readContract({
      address: USDCE_ADDRESS,
      abi: erc20Abi,
      functionName: "balanceOf",
      args: [account.address],
    });

    if (usdcBalance === 0n) {
      console.log("-> 0 USDC.e found in Funder wallet. Are you sure you have deposited USDC.e on Polygon?");
      process.exit(0);
    }

    console.log(`-> Found ${(Number(usdcBalance) / 1e6).toFixed(2)} USDC.e. Initializing wrap...`);

    // 2. Approve Onramp to spend USDC.e
    const approveHash = await walletClient.writeContract({
      address: USDCE_ADDRESS,
      abi: erc20Abi,
      functionName: "approve",
      args: [ONRAMP_ADDRESS, usdcBalance],
    });
    console.log("-> [1/4] Awaiting USDC.e approve transaction:", approveHash);
    await publicClient.waitForTransactionReceipt({ hash: approveHash });

    // 3. Wrap USDC.e to pUSD
    const wrapHash = await walletClient.writeContract({
      address: ONRAMP_ADDRESS,
      abi: onrampAbi,
      functionName: "wrap",
      args: [USDCE_ADDRESS, account.address, usdcBalance],
    });
    console.log("-> [2/4] Awaiting CollateralOnramp wrap transaction:", wrapHash);
    await publicClient.waitForTransactionReceipt({ hash: wrapHash });
    console.log("-> [3/4] pUSD minted successfully!");

    // 4. Update ClobClient native allowance for pUSD
    const l1Client = new ClobClient({ host: CLOB_HOST, chain: POLYGON_CHAIN_ID, signer: walletClient });
    const creds = await l1Client.createOrDeriveApiKey();
    const clobClient = new ClobClient({
      host: CLOB_HOST,
      chain: POLYGON_CHAIN_ID,
      signer: walletClient,
      creds,
    });

    console.log("-> [4/4] Generating infinite spend allowance for the V2 Exchange Proxy...");
    await clobClient.updateBalanceAllowance({ asset_type: AssetType.COLLATERAL });

    console.log("\n✅ Setup Complete! Your Funder wallet is fully provisioned for V2 API Trading.");

  } else if (action === "unwrap") {
    console.log("-> Manual unwrapping requires the explicit Offramp address, which is officially provided by the Polymarket interface.");
    console.log("-> Please visit https://polymarket.com on April 26th and hit 'Withdraw' to natively unwrap back to standard USDC.e!");
  }
}

run().catch(console.error);
