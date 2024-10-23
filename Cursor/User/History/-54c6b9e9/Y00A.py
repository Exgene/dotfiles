from x_whatsapp import WhatsappClient

client = WhatsappClient(DEBUG=True)


async def main():
    await client.initialize_playwright()
    await client.login()


if __name__ == "__main__":
    import asyncio

    asyncio.run(main())
