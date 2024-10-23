// how many users are active?
// what is the average age of all users
// list the top 5 common fruits among the users
// show all persons from usa
// show no of people having eyecolor green
// group data into no of males and females
// show all females having green eye color
// which country has the highest number of registered user
// show recently registered user
// show name, age of all users having tag ad
// Inserting sample user data

use("user");
// db.users.insertMany([
//   {
//     name: "Alice",
//     age: 30,
//     country: "USA",
//     eyeColor: "green",
//     fruits: ["apple", "banana"],
//     tags: ["ad"],
//   },
//   {
//     name: "Bob",
//     age: 25,
//     country: "USA",
//     eyeColor: "blue",
//     fruits: ["banana", "orange"],
//     tags: [],
//   },
//   {
//     name: "Charlie",
//     age: 35,
//     country: "Canada",
//     eyeColor: "green",
//     fruits: ["apple", "grape"],
//     tags: ["ad"],
//   },
//   {
//     name: "David",
//     age: 28,
//     country: "USA",
//     eyeColor: "brown",
//     fruits: ["banana", "kiwi"],
//     tags: [],
//   },
//   {
//     name: "Eve",
//     age: 22,
//     country: "USA",
//     eyeColor: "green",
//     fruits: ["apple", "banana"],
//     tags: ["ad"],
//   },
//   {
//     name: "Frank",
//     age: 40,
//     country: "UK",
//     eyeColor: "blue",
//     fruits: ["orange", "grape"],
//     tags: [],
//   },
//   {
//     name: "Grace",
//     age: 29,
//     country: "USA",
//     eyeColor: "green",
//     fruits: ["banana", "apple"],
//     tags: ["ad"],
//   },
//   {
//     name: "Hank",
//     age: 33,
//     country: "USA",
//     eyeColor: "brown",
//     fruits: ["kiwi", "banana"],
//     tags: [],
//   },
//   {
//     name: "Ivy",
//     age: 27,
//     country: "USA",
//     eyeColor: "green",
//     fruits: ["apple", "banana"],
//     tags: [],
//   },
//   {
//     name: "Jack",
//     age: 31,
//     country: "Canada",
//     eyeColor: "blue",
//     fruits: ["grape", "orange"],
//     tags: [],
//   },
// ]);

// 1. How many users are active?
// db.users.countDocuments({});

// // // 2. What is the average age of all users?
// db.users.aggregate([{ $group: { _id: null, averageAge: { $avg: "$age" } } }]);

// // // 3. List the top 5 common fruits among the users
// db.users.aggregate([
//   { $unwind: "$fruits" },
//   { $group: { _id: "$fruits", count: { $sum: 1 } } },
//   { $sort: { count: -1 } },
//   { $limit: 5 },
// ]);

// // // 4. Show all persons from USA
// db.users.find({ country: "USA" });

// // 5. Show number of people having eye color green
// db.users.countDocuments({ eyeColor: "green" });

// // 6. Group data into number of males and females (assuming gender is added)
// db.users.aggregate([{ $group: { _id: "$gender", count: { $sum: 1 } } }]);

// // 7. Show all females having green eye color (assuming gender is added)
db.users.find({ gender: "female", eyeColor: "green" });

// // 8. Which country has the highest number of registered users
// db.users.aggregate([
//   { $group: { _id: "$country", count: { $sum: 1 } } },
//   { $sort: { count: -1 } },
//   { $limit: 1 },
// ]);

// // 9. Show recently registered user (assuming a registration date field is added)
// db.users.find().sort({ registrationDate: -1 }).limit(1);

// // 10. Show name, age of all users having tag 'ad'
// db.users.find({ tags: "ad" }, { name: 1, age: 1 });
