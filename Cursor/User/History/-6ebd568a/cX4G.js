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

  const bookCollection = JSON.parse(data);

  const server = http.createServer((req, res) => {
    const { pathname, query } = url.parse(req.url, true);
    switch (pathname) {
      case "/":
        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(JSON.stringify(bookCollection));
        break;

      case "/filterByTitle":
        const searchTitle = query.title;
        const foundBook = bookCollection.find(
          (book) => book.title === searchTitle
        );
        if (foundBook) {
          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify(foundBook));
        } else {
          res.writeHead(404, { "Content-Type": "text/plain" });
          res.end("Book not found");
        }
        break;

      case "/filterByLanguage":
        const searchLanguage = query.language;
        const filteredBooks = bookCollection.filter(
          (book) => book.language === searchLanguage
        );
        if (filteredBooks.length > 0) {
          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify(filteredBooks));
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
