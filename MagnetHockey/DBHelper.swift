import SpriteKit
import SQLite

class DBHelper
{
    static let shared = DBHelper()

    var database: Connection!
    let magnetHockeyTable = Table("MagnetHockey")
    let topScore = Expression<Int>("topScore")
    let bottomScore = Expression<Int>("bottomScore")
    let magnetWins = Expression<Int>("magnetPoints")
    let goalWins = Expression<Int>("goalPoints")
    // ? allows expression to be optional
//    let name = Expression<String?>("")
//    let email = Expression<String?>("")
    
    func createDatabase()
    {
        do
        {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("game").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch
        {
            print(error)
        }
    }
    
    func createTable()
    {
        let createTable = self.magnetHockeyTable.create { table in
            table.column(self.topScore)
            table.column(self.bottomScore)
            table.column(self.magnetWins)
            table.column(self.goalWins)
        }
        
        do
        {
            try self.database.run(createTable)
        }
        catch
        {
            print(error)
        }
    }
    
    func insertUser(topScoreGame: Int, bottomScoreGame: Int, magnetWinsGame: Int, goalWinsGame: Int)
    {
        let insertUser = self.magnetHockeyTable.insert(topScore <- topScoreGame, bottomScore <- bottomScoreGame, magnetWins <- magnetWinsGame, goalWins <- goalWinsGame)
        
        do
        {
            try self.database.run(insertUser)
            print("INSERTED USER")
        }
        catch
        {
            print(error)
        }
    }
    
    func listUsers()
    {
//        do
//        {
//            let users = try self.database.prepare(self.magnetHockeyTable)
//            for user in users
//            {
//                print("userID: \(user[self.id]), name: \(user[self.name]), email: \(user[self.email])")
//            }
//            print(users)
//        }
//        catch
//        {
//            print(error)
//        }
    }
}
