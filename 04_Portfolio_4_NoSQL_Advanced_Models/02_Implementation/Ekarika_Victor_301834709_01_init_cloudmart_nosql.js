// CloudMart NoSQL Document Model Initialization
db = db.getSiblingDB("cloudmart_nosql");

// Reset collection for idempotent execution
db.products.drop();

// Insert product documents with dynamic, category-specific schemas
db.products.insertMany([
  {
    sku: "ELEC-1001",
    name: "UltraBook Pro 15",
    category: "Electronics",
    brand: "TechCorp",
    price: 1299.99,
    stock_quantity: 45,
    tags: ["laptop", "work", "portable", "intel"],
    attributes: {
      processor: "Intel Core i7-13700H",
      ram_gb: 16,
      storage_ssd_gb: 512,
      screen_size_inches: 15.6,
      display_type: "OLED"
    },
    ratings: { average: 4.8, review_count: 124 },
    created_at: new Date("2026-01-15T10:00:00Z")
  },
  {
    sku: "ELEC-1002",
    name: "NoiseCancel Wireless Headphones",
    category: "Electronics",
    brand: "AudioPro",
    price: 249.50,
    stock_quantity: 80,
    tags: ["audio", "bluetooth", "wireless", "noise-canceling"],
    attributes: {
      battery_life_hours: 30,
      bluetooth_version: "5.3",
      has_microphone: true,
      color: "Matte Black"
    },
    ratings: { average: 4.6, review_count: 89 },
    created_at: new Date("2026-02-01T14:30:00Z")
  },
  {
    sku: "CLOT-2001",
    name: "Organic Cotton Casual T-Shirt",
    category: "Apparel",
    brand: "EcoWear",
    price: 29.99,
    stock_quantity: 200,
    tags: ["cotton", "eco-friendly", "casual", "summer"],
    attributes: {
      material: "100% Organic Cotton",
      available_sizes: ["S", "M", "L", "XL"],
      available_colors: ["White", "Navy", "Olive"],
      care_instructions: "Machine wash cold, tumble dry low"
    },
    ratings: { average: 4.3, review_count: 52 },
    created_at: new Date("2026-02-10T09:15:00Z")
  },
  {
    sku: "BOOK-3001",
    name: "Advanced Database Systems Architecture",
    category: "Books",
    brand: "Academic Press",
    price: 89.99,
    stock_quantity: 30,
    tags: ["textbook", "database", "sql", "nosql", "architecture"],
    attributes: {
      authors: ["Dr. Aris Thorne", "Prof. Elena Rostova"],
      isbn_13: "978-1234567890",
      pages: 640,
      format: "Hardcover",
      edition: 3
    },
    ratings: { average: 4.9, review_count: 18 },
    created_at: new Date("2026-03-01T11:00:00Z")
  }
]);

// Create indexes for performance testing
db.products.createIndex({ category: 1, price: 1 });
db.products.createIndex({ sku: 1 }, { unique: true });
db.products.createIndex({ name: "text", tags: "text" });

print("--- CloudMart NoSQL Documents & Indexes Successfully Created ---");
print("Inserted documents count: " + db.products.countDocuments());