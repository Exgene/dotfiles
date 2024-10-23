import sqlite3


def create_database():
    """Creates a SQLite database named main.sqlite."""
    db_name = "main.sqlite"
    connection = sqlite3.connect(db_name)
    cursor = connection.cursor()

    # Create a sample table
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS chats (
            chatId INTEGER NOT NULL,
            messageId INTEGER PRIMARY KEY AUTOINCREMENT,
            provider TEXT NOT NULL,
            sender TEXT NOT NULL,
            time_sent TEXT NOT NULL,
            message TEXT NOT NULL,
            PRIMARY KEY(chatId, messageId)
        )
    """
    )

    connection.commit()
    connection.close()


def insert_message(
    chatId: int, provider: str, sender: str, time_sent: str, message: str
):
    """Inserts a message into the chats table."""
    connection = sqlite3.connect("main.sqlite")
    cursor = connection.cursor()

    cursor.execute(
        "INSERT INTO chats (chatId, provider, sender, time_sent, message) VALUES (?, ?, ?, ?, ?)",
        (
            chatId,
            provider,
            sender,
            time_sent,
            message,
        ),  # Ensure parameters are passed correctly
    )


create_database()
insert_message(1, "test", "test", "2023-10-01 12:00:00", "test")
