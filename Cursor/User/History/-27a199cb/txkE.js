// Select the database to use.
use("mycompany");

// insert person details

// db.persons.insertMany([
//   {
//     name: "John Doe",
//     age: 30,
//     bio: "Software Engineer",
//     hobbies: ["reading", "hiking"],
//     experience: [
//       { company: "ABC Corp", duration: "2 years" },
//       { company: "XYZ Inc", duration: "1 year" },
//     ],
//     identity: {
//       hasPassport: true,
//       hasAadhar: true,
//     },
//   },
//   {
//     name: "Jane Smith",
//     age: 25,
//     bio: "Data Analyst",
//     hobbies: ["painting", "cooking"],
//     experience: [
//       { company: "PQR Ltd", duration: "3 years" },
//       { company: "MNO Pvt", duration: "2 years" },
//     ],
//     identity: {
//       hasPassport: false,
//       hasAadhar: true,
//     },
//   },
// ]);

db.persons.find().pretty();

// db.createCollection("product");
// db.createCollection("inventory");

// db.product.bulkWrite(
//   [
//     {insertOne:
//       {
//         name: "marker",
//         price: 15,
//         stock: 10,
//       }
//     },{insertOne:
//       {
//         name: "scale",
//         price: 5,
//         stock: 20,
//       },
//     },
//     {updateOne: {
//       filter: {name: "marker"},
//       update: {$set: {price: 20}}
//     }}
//   ]
// )

// db.inventory.bulkWrite([
//   {
//     insertOne: {
//       p_id: 1,
//       stock: 10,
//     },
//   },
//   {
//     insertOne: {
//       p_id: 2,
//       stock: 20,
//     },
//   },
//   {
//     updateOne: {
//       filter: { p_id: 1 },
//       update: { $set: { stock: 15 } },
//     },
//   },
// ]);
// db.product.find().pretty();

// left outer join

db.product.aggregate([
  {
    $lookup: {
      from: "inventory",
      localField: "id",
      foreignField: "p_id",
      as: "i_inventory",
    },
  },
]);

// right outer join

// db.inventory.aggregate([
//   {
//     $lookup: {
//       from: "product",
//       localField: "p_id",
//       foreignField: "id",
//       as: "product",
//     },
//   },
// ]);

// inner join
db.product.aggregate([
  {
    $lookup: {
      from: "inventory",
      localField: "id",
      foreignField: "p_id",
      as: "inventory",
    },
  },
  {
    $match: {
      i_inventory: { $ne: [] },
    },
  },
]);
