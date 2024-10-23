from x_whatsapp import WhatsappClient

client = WhatsappClient(DEBUG=True)
await client.initialize_playwright()
