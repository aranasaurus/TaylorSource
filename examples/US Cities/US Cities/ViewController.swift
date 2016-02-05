//
//  ViewController.swift
//  US Cities
//
//  Created by Daniel Thorpe on 10/05/2015.
//  Copyright (c) 2015 Daniel Thorpe. All rights reserved.
//

import UIKit
import YapDatabase
import YapDatabaseExtensions
import TaylorSource

class CityCell: UICollectionViewCell {
    
    @IBOutlet weak var cityLabel: UILabel?
    @IBOutlet weak var populationLabel: UILabel?

    class func configuration(formatter: NSNumberFormatter) -> CitiesDatasource.Datasource.FactoryType.CellConfiguration {
        return { (cell, city, index) in
            cell.cityLabel?.font = UIFont.preferredFontForTextStyle(city.capital ? UIFontTextStyleHeadline : UIFontTextStyleBody)
            cell.cityLabel?.text = city.name
            cell.populationLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            cell.populationLabel?.text = formatter.stringFromNumber(NSNumber(integer: city.population))
        }
    }
}

struct CitiesDatasource: DatasourceProviderType {
    typealias Factory = YapDBFactory<City, CityCell, UICollectionViewCell, UICollectionView>
    typealias Datasource = YapDBDatasource<Factory>

    let readWriteConnection: YapDatabaseConnection
    let formatter: NSNumberFormatter
    let editor = NoEditor()
    var datasource: Datasource

    init(db: YapDatabase, view: Factory.ViewType, threshold: Int) {

        formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.perMillSymbol = ","
        formatter.allowsFloats = false

        readWriteConnection = db.newConnection()

        datasource = Datasource(id: "cities datasource", database: db, factory: Factory(), processChanges: view.processChanges, configuration: City.cities(abovePopulationThreshold: threshold))

        datasource.factory.registerCell(.NibWithIdentifier(UINib(nibName: "CityCell", bundle: nil), "cell"), inView: view, configuration: CityCell.configuration(formatter))
        datasource.factory.registerTextWithKind(.Header) { index in
            if let state: State = index.transaction.readByKey(index.group) {
                return state.name
            }
            return .None
        }
    }

    func addCity(city: City, toState state: State) {
        readWriteConnection.readWriteWithBlock { transaction in
            transaction.write(state)
            transaction.write(city)
        }
    }
}

class ViewController: UICollectionViewController {

    @IBOutlet weak var addButton: UIBarButtonItem!

    lazy var data = USStatesAndCities()
    var wrapper: CollectionViewDataSourceProvider<CitiesDatasource>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Some US Cities & States", comment: "Some US Cities & States")
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: collectionView!.frame.width - 100, height: 56)
        
        let datasource = CitiesDatasource(db: database, view: collectionView!, threshold: 20_000)
        configureDatasource(datasource)
        
        let oregon = State(name: "Oregon")
        datasource.addCity(City.init(name: "Milwaukie", population: 20_512, capital: false, stateId: "Oregon"), toState: oregon)
//        datasource.addCity(City.init(name: "Portland", population: 603_106, capital: false, stateId: "Oregon"), toState: oregon)
//        datasource.addCity(City.init(name: "Salem", population: 154_637, capital: true, stateId: "Oregon"), toState: oregon)
    }

    func configureDatasource(datasource: CitiesDatasource) {
        wrapper = CollectionViewDataSourceProvider(datasource)
        collectionView?.dataSource = wrapper.collectionViewDataSource
        data.loadIntoDatabase(database)
    }
}

// MARK: - Dataloader

struct USStatesAndCities {
    let data: NSDictionary

    init() {
        let path = NSBundle.mainBundle().pathForResource("USStatesAndCities", ofType: "plist")
        data = NSDictionary(contentsOfFile: path!)!
    }

    func cityDataForState(stateName: String) -> [NSDictionary] {
        return (data[stateName] as! NSDictionary)["StateCities"] as! [NSDictionary]
    }

    func loadIntoDatabase(db: YapDatabase) {

        let connection = db.newConnection()

        let states: [State] = connection.readAll()
        let stateNames = states.map { $0.name }
        let remainingStateNames = (data.allKeys as! [String]).filter { !stateNames.contains($0) }

        for stateName in remainingStateNames {

            let state = State(name: stateName)
            let cities = cityDataForState(stateName).map { (cityData: NSDictionary) -> City in
                let cityName = cityData["CityName"] as! String
                let population = (cityData["CityPopulation"] as! NSNumber).integerValue
                let isCapital = (cityData["isCapital"] as? NSNumber)?.boolValue ?? false
                return City(name: cityName, population: population, capital: isCapital, stateId: state.identifier)
            }

            connection.asyncWrite(state) { _ in
                connection.asyncWrite(cities) { _ in
                    print("Wrote \(state.name) cities to database.")
                }
            }
        }
    }
}

