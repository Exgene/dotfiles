use("companyrecords");

db.employees.find();

// db.employees.find({ "experience.company": "Amazon" });

// db.employees.countDocuments({ "experience.company": "Spotify" });

// db.employees.aggregate([
//   {
//     // this line is not needed but it gives error due to some documents missing the experience field
//     $match: {
//       experience: { $exists: true, $ne: [] },
//     },
//   },
//   {
//     $match: {
//       $expr: { $gte: [{ $size: "$experience" }, 3] },
//     },
//   },
//   {
//     $count: "numberOfEmployees",
//   },
// ]);

// change name of age field to employeesAge

// db.employees.updateMany({}, { $rename: { age: "employeesAge" } });

// db.employees.updateMany(
//   {
//     "experience.duration": { $lte: 1 }, // Match experiences with duration less than or equal to 1
//   },
//   { $set: { "experience.$[elem].projectAssign": false } }, // Set projectAssign for the matched array items
//   { arrayFilters: [{ "elem.duration": { $lte: 1 } }] } // Filter for the specific array items
// );

// db.employees.find({ "experience.duration": { $lte: 1 } }).pretty();

// db.employees.find({ projectAssign: false }).pretty();

// remove hasMacBook field from user named Ravi

// db.employees.updateOne({ name: "Ravi" }, { $unset: { hasMacBook: "" } });
// db.employees.find({ name: "Ravi" }).pretty();

// db.employees.reIndex(
//   { employeesAge: 1 },
//   { partialFilterExpression: { employeesAge: { $gt: 18 } } }
// );

// db.employees.find({ employeesAge: { $gt: 18 } }).explain("executionStats");

// db.employees.createIndex({ employeesAge: 1, name: 1 });

// db.employees.find({ employeesAge: { $gt: 18 } }).explain("executionStats");

// db.employees
//   .find({ employeesAge: { $gt: 18 }, name: { $regex: "^A" } })
//   .explain("executionStats");

// db.employees.find({ name: { $regex: "^A" } }).explain("executionStats");
// db.employeess
//   .find({
//     $or: [{ bio: { $regex: "code" } }, { bio: { $regex: "coding" } }],
//   })
//   .pretty();

// db.employees
//   .find({}, { name: 1, _id: 0, employeesAge: 1 })
//   .sort({ employeesAge: 1 })
//   .pretty();

// db.employees
//   .aggregate([
//     { $match: { gender: "Male" } }, // Filter for male employees
//     { $group: { _id: "$age", count: { $sum: 1 } } }, // Group by age and count
//     { $sort: { count: -1 } }, // Sort by count in descending order
//   ])
//   .pretty();

// db.createView("FemaleRecordsView", "employees", [
//   { $match: { gender: "Female" } },
// ]);
// db.FemaleRecordsView.find().pretty();
// db.employees.createIndex({ bio: "text" });

// db.FemaleRecordsView.drop();

// Create the Department collection with schema validation
// db.createCollection("Department", {
//   validator: {
//     $jsonSchema: {
//       bsonType: "object",
//       required: ["depId", "departName", "empId"],
//       properties: {
//         depId: {
//           bsonType: "int",
//           description: "must be an integer and is required",
//         },
//         departName: {
//           bsonType: "string",
//           description: "must be a string and is required",
//         },
//         empId: {
//           bsonType: "int",
//           description: "must be an integer and is required",
//         },
//       },
//     },
//   },
// });

// db.employees.find({ bio: { $search: "code coding" } });

// db.Department.insertMany([
//   {
//     depId: 1,
//     departName: "HR",
//     empId: 101,
//   },
//   {
//     depId: 2,
//     departName: "IT",
//     empId: 102,
//   },
//   {
//     depId: 3,
//     departName: "Finance",
//     empId: 103,
//   },
// ]);

// db.Department.insertMany([
//   {
//     depId: "1",
//     departName: "HR",
//     empId: 105,
//   },
//   {
//     depId: 2,
//     departName: 6,
//     empId: 106,
//   },
// ]);

// db.Department.find();

// let empIdCounter = 100; // Starting empId

// db.employees.find().forEach(function (employee) {
//   db.employees.updateOne(
//     { _id: employee._id }, // Match the employee by their unique ID
//     { $set: { empId: empIdCounter++ } } // Set empId and increment the counter
//   );
// });

// db.employees.dropIndexes();
// db.employees.aggregate([
//   {
//     $match: { gender: "Male" },
//   },
//   {
//     $group: {
//       _id: "$employeesAge",
//       count: { $sum: 1 },
//     },
//   },
//   {
//     $sort: { count: -1 },
//   },
// ]);

// db.employees
//   .aggregate([
//     {
//       $lookup: {
//         from: "Department", // The collection to join
//         localField: "empId", // Field from the semployees collection
//         foreignField: "empId", // Field from the Department collection
//         as: "departmentDetails", // Output array field
//       },
//     },
//   ])
//   .pretty();

// db.employees.find({ name: "Maria", age: 28 });

// db.employees.updateOne(
//   { name: "Maria", age: 28 },
//   { $set: { hasMacBook: true } },
//   { upsert: true }
// );

db.employees.find({ $text: { $search: "code coding" } }).pretty();
