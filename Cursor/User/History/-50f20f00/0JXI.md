---
title: Overview
description: Implementation of an external brain for WhatsApp
sidebar:
  order: 1
---

Python library for interacting with WhatsApp using Playwright

# Core Functions

The library provides a set of core functions to interact with WhatsApp. All the api's provided are async in nature.

#### Authentication

- **login**
  - Logs in to WhatsApp Web.
  - Saves the browser context to a file to skip re-authentication.
- **logout**
  - Logs out of your current WhatsApp session.

#### Finding Users

- **find_user(str)**
  - TODO: Do not open the chat panel corresponding to the user.
  - Returns False if a username starting with `str` does not exist.
  - Returns the best matching username that starts with `str` if it exists.
  - For an exact match, you need to perform an additional check to see if `str` equals the returned value.

#### Creating New Chats

- **check_valid_number(str)**
- **create_new_chat(str)**
  - TODO: Check whether the provided phone number is valid or invalid.
  - Currently, if the phone number is invalid, the program breaks.
  - Return True if the provided phone number is valid; otherwise, return False.
  - Be able to handle various types of phone number strings (via regex).
  - Use the country code `+91` if it is not present.
  - Consider changing the name to avoid confusion (if the user needs to find an already saved contact whose number is known, they should use the `find_user` function).
  - Currently, the `str` should be in the format "+911234567890".

#### Locators

- **get_focused_element_locator()**
  - Returns None or the locator for the currently focused element.
- **get_search_box_locator()**
  - Returns the Playwright locator for the search box.

#### Helper Functions

- **select_text_and_delete()**
  - Selects all text in the currently selected item and deletes it.
- **search_pane_scroll_down()**
  - Scrolls down the search pane to load more user chats.
- **chat_pane_scroll_up()**
  - Scrolls up the chat pane to load more messages.

#### Search & Chat Pane Functions

- **New Message Listener**
  - Checks the first chat every 10 seconds.
  - Retrieves notifications.
    - Uses notifications to obtain new messages.

- **Search Pane**
  - **get_first_chat(ignore_pinned: bool = True)**
    - TODO: This function currently opens the chat.
      - Retrieve the first chat without opening the chats.
    - Selects the most recent chat (by default, ignoring all pinned chats).

- **Chat Pane**
  - **get_newest_message**
  - **get_oldest_message**
  - **retrieve_all_messages**

#### Attachment Details

- Type → Image, PDF, Other
- Size → In bytes or megabytes
- Link (to the actual attachment)
  - The attachment could be saved in another database or the same one.

#### Sending Messages

- Sending a regular message
  - To an existing contact
  - To a new contact (via phone number)
- Replying to a message
- Sending images, PDFs, videos, and attachments
- Forwarding a message
- Sending stickers

---
