//
//  DatabaseManager.swift
//  mcdonald POS
//
//  Created by Jayden on 15/1/2026.
//  SwiftUI Migration - SQLite database with JSON initialization
//

import Foundation
import SQLite
import SwiftyJSON
import Combine

class DatabaseManager: ObservableObject {
    // MARK: - Published Properties
    @Published var catalogs: [Catalog] = []
    @Published var foods: [Food] = []
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private var db: Connection?
    private let usersTable = Table("user")
    private let catalogsTable = Table("catalog")
    private let foodsTable = Table("food")

    // MARK: - Initialization
    init() {
        setupDatabase()
    }

    private func setupDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            let dbPath = "\(path)/db.sqlite3"

            db = try Connection(dbPath)
            debugPrint("Database connected at: \(dbPath)")

            // Create tables
            try createTables()

            // Check if database is empty and initialize from JSON
            try initializeFromJSONIfNeeded()

        } catch {
            errorMessage = "Failed to connect to database: \(error.localizedDescription)"
            debugPrint("Database connection error: \(error)")
        }
    }

    private func createTables() throws {
        guard let db = db else { return }

        // Create user table
        try db.run(usersTable.create(ifNotExists: true) { t in
            t.column(Expression<Int64>("id"), primaryKey: true)
            t.column(Expression<String>("username"), unique: true)
            t.column(Expression<String>("password"))
            t.column(Expression<String>("role"))
            t.column(Expression<String>("lastTime"))
        })

        // Create catalog table
        try db.run(catalogsTable.create(ifNotExists: true) { t in
            t.column(Expression<Int64>("id"), primaryKey: true)
            t.column(Expression<String>("name_zh"))
            t.column(Expression<String>("name_en"))
            t.column(Expression<String>("image_zh"))
            t.column(Expression<String>("image_en"))
            t.column(Expression<Int64>("position"))
        })

        // Create food table
        try db.run(foodsTable.create(ifNotExists: true) { t in
            t.column(Expression<Int64>("id"), primaryKey: true)
            t.column(Expression<Int64>("catalogId"))
            t.column(Expression<String>("name_zh"))
            t.column(Expression<String>("name_en"))
            t.column(Expression<String>("image_zh"))
            t.column(Expression<String>("image_en"))
            t.column(Expression<Float64>("price"))
            t.column(Expression<Float64>("meal_price"))
            t.column(Expression<Bool>("is_breakfasts"))
            t.column(Expression<Bool>("is_set_meal"))
            t.column(Expression<Bool>("is_set_option"))
            t.column(Expression<Bool>("is_set_drink"))
        })

        debugPrint("Tables created successfully")
    }

    private func initializeFromJSONIfNeeded() throws {
        guard let db = db else { return }

        // Check if user table is empty
        let userCount = try db.scalar(usersTable.count)
        if userCount > 0 {
            debugPrint("Database already initialized with \(userCount) users")
            return
        }

        debugPrint("Database empty, initializing from JSON files...")

        // Load and insert users
        do {
            try initializeUsersFromJSON()
        } catch {
            debugPrint("Failed to initialize users: \(error)")
            throw error
        }

        // Load and insert catalogs
        do {
            try initializeCatalogsFromJSON()
        } catch {
            debugPrint("Failed to initialize catalogs: \(error)")
            throw error
        }

        // Load and insert foods
        do {
            try initializeFoodsFromJSON()
        } catch {
            debugPrint("Failed to initialize foods: \(error)")
            throw error
        }

        debugPrint("Database initialized successfully from JSON")
    }

    private func initializeUsersFromJSON() throws {
        guard let db = db,
              let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
            throw DatabaseError.queryFailed("Users JSON not found")
        }

        let data = try Data(contentsOf: url)
        let json = try JSON(data: data)

        for userJson in json.arrayValue {
            let insert = usersTable.insert(
                Expression<String>("username") <- userJson["username"].stringValue,
                Expression<String>("password") <- userJson["password"].stringValue.md5Value,
                Expression<String>("role") <- userJson["role"].stringValue,
                Expression<String>("lastTime") <- Date().ISO8601Format()
            )
            try db.run(insert)
        }

        debugPrint("Inserted \(json.arrayValue.count) users")
    }

    private func initializeCatalogsFromJSON() throws {
        guard let db = db,
              let url = Bundle.main.url(forResource: "catalogs", withExtension: "json") else {
            throw DatabaseError.queryFailed("Catalogs JSON not found")
        }

        let data = try Data(contentsOf: url)
        let json = try JSON(data: data)

        for catalogJson in json.arrayValue {
            let insert = catalogsTable.insert(
                Expression<Int64>("id") <- catalogJson["id"].int64Value,
                Expression<String>("name_zh") <- catalogJson["name_zh"].stringValue,
                Expression<String>("name_en") <- catalogJson["name_en"].stringValue,
                Expression<String>("image_zh") <- catalogJson["image_zh"].stringValue,
                Expression<String>("image_en") <- catalogJson["image_en"].stringValue,
                Expression<Int64>("position") <- catalogJson["position"].int64Value
            )
            try db.run(insert)
        }

        debugPrint("Inserted \(json.arrayValue.count) catalogs")
    }

    private func initializeFoodsFromJSON() throws {
        guard let db = db,
              let url = Bundle.main.url(forResource: "foods", withExtension: "json") else {
            throw DatabaseError.queryFailed("Foods JSON not found")
        }

        let data = try Data(contentsOf: url)
        let json = try JSON(data: data)

        debugPrint("Foods JSON count: \(json.arrayValue.count)")

        for foodJson in json.arrayValue {
            let insert = foodsTable.insert(
                Expression<Int64>("id") <- foodJson["id"].int64Value,
                Expression<Int64>("catalogId") <- foodJson["catalogId"].int64Value,
                Expression<String>("name_zh") <- foodJson["name_zh"].stringValue,
                Expression<String>("name_en") <- foodJson["name_en"].stringValue,
                Expression<String>("image_zh") <- foodJson["image_zh"].stringValue,
                Expression<String>("image_en") <- foodJson["image_en"].stringValue,
                Expression<Float64>("price") <- foodJson["price"].doubleValue,
                Expression<Float64>("meal_price") <- foodJson["meal_price"].doubleValue,
                Expression<Bool>("is_breakfasts") <- foodJson["is_breakfasts"].boolValue,
                Expression<Bool>("is_set_meal") <- foodJson["is_set_meal"].boolValue,
                Expression<Bool>("is_set_option") <- foodJson["is_set_option"].boolValue,
                Expression<Bool>("is_set_drink") <- foodJson["is_set_drink"].boolValue
            )
            try db.run(insert)
        }

        debugPrint("Inserted \(json.arrayValue.count) foods")
    }

    // MARK: - User Authentication
    @MainActor
    func loginUser(username: String, password: String) async throws -> User {
        guard let db = db else {
            throw DatabaseError.notConnected
        }

        isLoading = true
        defer { isLoading = false }

        let idExpr = Expression<Int64>("id")
        let usernameExpr = Expression<String>("username")
        let passwordExpr = Expression<String>("password")
        let roleExpr = Expression<String>("role")
        let lastTimeExpr = Expression<String>("lastTime")

        // Query user with MD5 hashed password
        let query = usersTable
            .filter(usernameExpr == username && passwordExpr == password.md5Value)

        for row in try db.prepare(query) {
            let lastTimeString = row[lastTimeExpr]
            let lastTime = lastTimeString.toDate() ?? Date()

            let user = User(
                username: row[usernameExpr],
                password: row[passwordExpr],
                role: row[roleExpr],
                lastTime: lastTime
            )

            // Update last login time
            let update = usersTable
                .filter(usernameExpr == username)
                .update(Expression<String>("lastTime") <- Date().ISO8601Format())
            try db.run(update)

            currentUser = user
            return user
        }

        throw DatabaseError.invalidCredentials
    }

    // MARK: - Catalog Operations
    @MainActor
    func loadCatalogs() async throws {
        guard let db = db else {
            throw DatabaseError.notConnected
        }

        isLoading = true
        defer { isLoading = false }

        var loadedCatalogs: [Catalog] = []

        let idExpr = Expression<Int64>("id")
        let nameZhExpr = Expression<String>("name_zh")
        let nameEnExpr = Expression<String>("name_en")
        let imageZhExpr = Expression<String>("image_zh")
        let imageEnExpr = Expression<String>("image_en")
        let positionExpr = Expression<Int64>("position")

        let query = catalogsTable.order(positionExpr)

        for row in try db.prepare(query) {
            let catalog = Catalog(
                id: row[idExpr],
                name_zh: row[nameZhExpr],
                name_en: row[nameEnExpr],
                image_zh: row[imageZhExpr],
                image_en: row[imageEnExpr],
                position: row[positionExpr]
            )
            loadedCatalogs.append(catalog)
        }

        catalogs = loadedCatalogs
    }

    // MARK: - Food Operations
    @MainActor
    func loadFoods(catalogId: Int64) async throws {
        guard let db = db else {
            throw DatabaseError.notConnected
        }

        isLoading = true
        defer { isLoading = false }

        var loadedFoods: [Food] = []

        let idExpr = Expression<Int64>("id")
        let catalogIdExpr = Expression<Int64>("catalogId")
        let nameZhExpr = Expression<String>("name_zh")
        let nameEnExpr = Expression<String>("name_en")
        let imageZhExpr = Expression<String>("image_zh")
        let imageEnExpr = Expression<String>("image_en")
        let priceExpr = Expression<Float64>("price")
        let mealPriceExpr = Expression<Float64>("meal_price")
        let isBreakfastsExpr = Expression<Bool>("is_breakfasts")
        let isSetMealExpr = Expression<Bool>("is_set_meal")
        let isSetOptionExpr = Expression<Bool>("is_set_option")
        let isSetDrinkExpr = Expression<Bool>("is_set_drink")

        let query = foodsTable.filter(catalogIdExpr == catalogId)

        for row in try db.prepare(query) {
            let food = Food(
                id: row[idExpr],
                catalogId: row[catalogIdExpr],
                name_zh: row[nameZhExpr],
                name_en: row[nameEnExpr],
                image_zh: row[imageZhExpr],
                image_en: row[imageEnExpr],
                price: row[priceExpr],
                meal_price: row[mealPriceExpr],
                is_breakfasts: row[isBreakfastsExpr],
                is_set_meal: row[isSetMealExpr],
                is_set_option: row[isSetOptionExpr],
                is_set_drink: row[isSetDrinkExpr]
            )
            loadedFoods.append(food)
        }

        foods = loadedFoods
    }

    @MainActor
    func loadFoodOptions(isBreakfasts: Bool) async throws -> [Food] {
        guard let db = db else {
            throw DatabaseError.notConnected
        }

        var loadedFoods: [Food] = []

        let idExpr = Expression<Int64>("id")
        let catalogIdExpr = Expression<Int64>("catalogId")
        let nameZhExpr = Expression<String>("name_zh")
        let nameEnExpr = Expression<String>("name_en")
        let imageZhExpr = Expression<String>("image_zh")
        let imageEnExpr = Expression<String>("image_en")
        let priceExpr = Expression<Float64>("price")
        let mealPriceExpr = Expression<Float64>("meal_price")
        let isBreakfastsExpr = Expression<Bool>("is_breakfasts")
        let isSetMealExpr = Expression<Bool>("is_set_meal")
        let isSetOptionExpr = Expression<Bool>("is_set_option")
        let isSetDrinkExpr = Expression<Bool>("is_set_drink")

        let query = foodsTable
            .filter(isBreakfastsExpr == isBreakfasts && isSetOptionExpr == true)

        for row in try db.prepare(query) {
            let food = Food(
                id: row[idExpr],
                catalogId: row[catalogIdExpr],
                name_zh: row[nameZhExpr],
                name_en: row[nameEnExpr],
                image_zh: row[imageZhExpr],
                image_en: row[imageEnExpr],
                price: row[priceExpr],
                meal_price: row[mealPriceExpr],
                is_breakfasts: row[isBreakfastsExpr],
                is_set_meal: row[isSetMealExpr],
                is_set_option: row[isSetOptionExpr],
                is_set_drink: row[isSetDrinkExpr]
            )
            loadedFoods.append(food)
        }

        return loadedFoods
    }

    @MainActor
    func loadDrinkOptions() async throws -> [Food] {
        guard let db = db else {
            throw DatabaseError.notConnected
        }

        var loadedFoods: [Food] = []

        let idExpr = Expression<Int64>("id")
        let catalogIdExpr = Expression<Int64>("catalogId")
        let nameZhExpr = Expression<String>("name_zh")
        let nameEnExpr = Expression<String>("name_en")
        let imageZhExpr = Expression<String>("image_zh")
        let imageEnExpr = Expression<String>("image_en")
        let priceExpr = Expression<Float64>("price")
        let mealPriceExpr = Expression<Float64>("meal_price")
        let isBreakfastsExpr = Expression<Bool>("is_breakfasts")
        let isSetMealExpr = Expression<Bool>("is_set_meal")
        let isSetOptionExpr = Expression<Bool>("is_set_option")
        let isSetDrinkExpr = Expression<Bool>("is_set_drink")

        let query = foodsTable.filter(isSetDrinkExpr == true)

        for row in try db.prepare(query) {
            let food = Food(
                id: row[idExpr],
                catalogId: row[catalogIdExpr],
                name_zh: row[nameZhExpr],
                name_en: row[nameEnExpr],
                image_zh: row[imageZhExpr],
                image_en: row[imageEnExpr],
                price: row[priceExpr],
                meal_price: row[mealPriceExpr],
                is_breakfasts: row[isBreakfastsExpr],
                is_set_meal: row[isSetMealExpr],
                is_set_option: row[isSetOptionExpr],
                is_set_drink: row[isSetDrinkExpr]
            )
            loadedFoods.append(food)
        }

        return loadedFoods
    }
}

// MARK: - Error Types
enum DatabaseError: LocalizedError {
    case notConnected
    case invalidCredentials
    case queryFailed(String)

    var errorDescription: String? {
        switch self {
        case .notConnected:
            return "数据库连接失败"
        case .invalidCredentials:
            return "用户名或密码错误"
        case .queryFailed(let reason):
            return "查询失败: \(reason)"
        }
    }
}
