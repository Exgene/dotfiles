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
            PRIMARY KEY(chatId, messageId)
        )
    """
    )

    connection.commit()
    connection.close()


create_database()
