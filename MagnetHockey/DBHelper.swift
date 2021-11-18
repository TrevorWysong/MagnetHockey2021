import SpriteKit
import SQLite

class DBHelper
{
    static let shared = DBHelper()

    var database: Connection!
    let magnetHockeyTable = Table("MagnetHockey")
    let airHockey1PTable = Table("AirHockey1P")
    let airHockey2PTable = Table("AirHockey2P")
    let allTable = Table("All")

    let topScore = Expression<Int>("topScore")
    let bottomScore = Expression<Int>("bottomScore")
    let magnetGoalsOrderTop = Expression<Int>("magnetGoalsOrderTop")
    let magnetGoalsOrderBottom = Expression<Int>("magnetGoalsOrderBottom")

    
    // 2 dimensional array of arrays of Ints
    var allArr: [[Int]] = []
    var magnetHockeyArr: [[Int]] = []
    var airHockey1PArr: [[Int]] = []
    var airHockey2PArr: [[Int]] = []

    
    
    // ? allows expression to be optional i.e. <Int?>
    
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
    
    func createTable(game: String)
    {
        if game == "MagnetHockey"
        {
            let createTable = self.magnetHockeyTable.create { table in
                table.column(self.topScore)
                table.column(self.bottomScore)
                table.column(self.magnetGoalsOrderTop)
                table.column(self.magnetGoalsOrderBottom)
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
        else if game == "AirHockey1P"
        {
            let createTable = self.airHockey1PTable.create { table in
                table.column(self.topScore)
                table.column(self.bottomScore)
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
        else if game == "AirHockey2P"
        {
            let createTable = self.airHockey2PTable.create { table in
                table.column(self.topScore)
                table.column(self.bottomScore)
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
        else if game == "All"
        {
            let createTable = self.allTable.create { table in
                table.column(self.topScore)
                table.column(self.bottomScore)
                table.column(self.magnetGoalsOrderTop)
                table.column(self.magnetGoalsOrderBottom)
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
    }
    
    func insertGame(game: String, topScoreGame: Int, bottomScoreGame: Int, magnetGoalsOrderGameTop: Int, magnetGoalsOrderGameBottom: Int)
    {
        if game == "MagnetHockey"
        {
            let insertGame = self.magnetHockeyTable.insert(topScore <- topScoreGame, bottomScore <- bottomScoreGame, magnetGoalsOrderTop <- magnetGoalsOrderGameTop, magnetGoalsOrderBottom <- magnetGoalsOrderGameBottom)
            do
            {
                try self.database.run(insertGame)
            }
            catch
            {
                print(error)
            }
        }
        else if game == "AirHockey1P"
        {
            let insertGame = self.airHockey1PTable.insert(topScore <- topScoreGame, bottomScore <- bottomScoreGame)
            do
            {
                try self.database.run(insertGame)
            }
            catch
            {
                print(error)
            }
        }
        else if game == "AirHockey2P"
        {
            let insertGame = self.airHockey2PTable.insert(topScore <- topScoreGame, bottomScore <- bottomScoreGame)
            do
            {
                try self.database.run(insertGame)
            }
            catch
            {
                print(error)
            }
        }
        else if game == "All"
        {
            let insertGame = self.allTable.insert(topScore <- topScoreGame, bottomScore <- bottomScoreGame)
            do
            {
                try self.database.run(insertGame)
            }
            catch
            {
                print(error)
            }
        }
    }
    
    func listGames(game: String)
    {
        if game == "MagnetHockey"
        {
            do
            {
                let games = try self.database.prepare(self.magnetHockeyTable)
                for game in games
                {
                    magnetHockeyArr.append([game[self.topScore], game[self.bottomScore], game[self.magnetGoalsOrderTop], game[self.magnetGoalsOrderBottom]])
                }
            }
            catch
            {
                print(error)
            }
        }
        else if game == "AirHockey1P"
        {
            do
            {
                let games = try self.database.prepare(self.airHockey1PTable)
                for game in games
                {
                    airHockey1PArr.append([game[self.topScore], game[self.bottomScore]])
                }
            }
            catch
            {
                print(error)
            }
        }
        else if game == "AirHockey2P"
        {
            do
            {
                let games = try self.database.prepare(self.airHockey2PTable)
                for game in games
                {
                    airHockey2PArr.append([game[self.topScore], game[self.bottomScore]])
                }
            }
            catch
            {
                print(error)
            }
        }
        else if game == "All"
        {
            do
            {
                let games = try self.database.prepare(self.allTable)
                for game in games
                {
                    allArr.append([game[self.topScore], game[self.bottomScore]])
                }
            }
            catch
            {
                print(error)
            }
        }
        
    }
    
    func deleteTables()
    {
        let deleteMagnetHockeyTable = self.magnetHockeyTable.delete()
        do
        {

            try self.database.run(deleteMagnetHockeyTable)
        }
        catch
        {
            print(error)
        }
        let deleteAirHockey2PTable = self.airHockey2PTable.delete()
        do
        {
            try self.database.run(deleteAirHockey2PTable)
        }
        catch
        {
            print(error)
        }
        let deleteAirHockey1PTable = self.airHockey1PTable.delete()
        do
        {
            try self.database.run(deleteAirHockey1PTable)
        }
        catch
        {
            print(error)
        }
        let deleteAllTable = self.allTable.delete()
        do
        {
            try self.database.run(deleteAllTable)
        }
        catch
        {
            print(error)
        }
    }
    
}
