import fs from "fs";
import http from "http";
import url from "url";
const SERVER_PORT = 3000;
const SERVER_HOST = "127.0.0.1";

fs.readFile("books.json", "utf8", (err, data) => {
  if (err != null) {
    console.error(err);
    return;
  }

  const book_collection = JSON.parse(data);

  const server = http.createServer((req, res) => {
    const { pathname, query } = url.parse(req.url, true);
    switch (pathname) {
      case "/":
        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(JSON.stringify(book_collection));
        break;

      case "/get_books_by_title":
        const search_title = query.title;
        const found_book = book_collection.find(
          (book) => book.title === search_title
        );
        if (found_book) {
          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify(found_book));
        } else {
          res.writeHead(404, { "Content-Type": "text/plain" });
          res.end("Book not found");
        }
        break;

      case "/get_books_by_language":
        const search_language = query.language;
        const filtered_books = book_collection.filter(
          (book) => book.language === search_language
        );
        if (filtered_books.length > 0) {
          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify(filtered_books));
        } else {
          res.writeHead(404, { "Content-Type": "text/plain" });
          res.end("No books found in the specified language");
        }
        break;

      default:
        res.writeHead(404, { "Content-Type": "text/plain" });
        res.end(`Page not found: ${pathname}`);
    }
  });

  server.listen(SERVER_PORT, SERVER_HOST, () => {
    console.log(`Server is running on http://${SERVER_HOST}:${SERVER_PORT}`);
  });
});
