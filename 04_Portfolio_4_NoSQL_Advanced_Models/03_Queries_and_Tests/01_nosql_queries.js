db = db.getSiblingDB("cloudmart_nosql");

print("\n=======================================================");
print("QUERY 1: Category & Price Range Filter (Compound Index)");
print("=======================================================");
var q1 = db.products.find({ category: "Electronics", price: { $lte: 1500 } }).projection({ sku: 1, name: 1, price: 1, _id: 0 });
printjson(q1.toArray());

print("\n=======================================================");
print("QUERY 2: Polymorphic Nested Attribute Search");
print("=======================================================");
var q2 = db.products.find({ "attributes.processor": { $regex: "Intel", $options: "i" } }).projection({ sku: 1, name: 1, "attributes.processor": 1, _id: 0 });
printjson(q2.toArray());

print("\n=======================================================");
print("QUERY 3: Array Tag Match (Flexibility Test)");
print("=======================================================");
var q3 = db.products.find({ tags: "wireless" }).projection({ sku: 1, name: 1, tags: 1, _id: 0 });
printjson(q3.toArray());

print("\n=======================================================");
print("QUERY 4: Execution Plan Analysis (Index Usage Verification)");
print("=======================================================");
var exp = db.products.find({ category: "Electronics", price: { $lte: 1500 } }).explain("executionStats");
var plan = exp.queryPlanner.winningPlan;
var inputStage = plan.inputStage ? plan.inputStage.stage : "N/A";
var indexName = plan.inputStage ? plan.inputStage.indexName : "N/A";

print("Winning Plan Stage: " + plan.stage);
print("Input Stage: " + inputStage);
print("Index Used: " + indexName);
print("Total Keys Examined: " + exp.executionStats.totalKeysExamined);
print("Total Documents Examined: " + exp.executionStats.totalDocsExamined);
print("Execution Time (ms): " + exp.executionStats.executionTimeMillis);

print("\n=======================================================");
print("QUERY 5: Dynamic Schema Evolution (Adding Field on-the-fly)");
print("=======================================================");
db.products.updateOne(
  { sku: "ELEC-1001" },
  { $set: { "attributes.warranty_years": 3, "promotions": ["Free Shipping", "Holiday Discount"] } }
);
var updated = db.products.find({ sku: "ELEC-1001" }).projection({ sku: 1, name: 1, "attributes.warranty_years": 1, promotions: 1, _id: 0 });
printjson(updated.toArray());

print("\n=======================================================");
print("Portfolio 4 Query Verification Complete");
print("=======================================================\n");