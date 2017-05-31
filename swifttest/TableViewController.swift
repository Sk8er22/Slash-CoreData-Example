//
//  TableViewController.swift
//  swifttest
//
//  Created by PEDRO ARMANDO MANFREDI on 30/5/17.
//  Copyright © 2017 Slash Mobility S.L. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class TableViewController: UITableViewController {
    
    //Init de variables
    var canciones = [CancionesClass]() // donde se guardara el Json preguntado
    var song = Song() // se utilizara para la escritura 1x1 de canciones durante el parseo
    var songs = [Song]() //array que se utilizara para llevar un seguimiento y update automático de la tabla con la BBDD
    var fetchResultsController : NSFetchedResultsController<Song>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //autosize de tabla
        tableView.estimatedRowHeight = 40
        self.tableView.rowHeight = UITableViewAutomaticDimension
        //Volvemos a preguntar en la BBDD
        let fetchRequest : NSFetchRequest<Song> = NSFetchRequest(entityName: "Song")
        //fetchRequest.sortDescriptors = NSSortDescriptor(key: <#T##String?#>, ascending: <#T##Bool#>)
        fetchRequest.sortDescriptors = [] //si quisieramos ordenarlo de una manera especifica
        //instanciamos el context, hacemos la consulta y seteamos el delegate
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                self.songs = fetchResultsController.fetchedObjects!
            }catch{
                print("error")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //name sección
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Results"
    }
    
    //rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(canciones.count)
        return songs.count
    }
    
    //configuramos la celda
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cancionesCell", for: indexPath) as! CancionesCell
        print("cargando \(indexPath.row)")
        cell.trackLabel.text = songs[indexPath.row].trackName
        cell.collectionLabel.text = songs[indexPath.row].collectionCensoredName
        cell.countryLabel.text = songs[indexPath.row].country
        return cell
    }
    
    
    func request(url: String){
        //Consulta
        print(url.description)
        Alamofire.request(url) .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)//utilizamos alamofire+swiftyJSON para obtener la respuesta
                for i in 0..<json["results"].count{
                    //          print("\(json["results"])")//cogemos el [diccionario] results y lo recorremos instanciando
                    let resultado = json["results"][i]
                    let cancion = CancionesClass(dictionary: resultado.dictionaryObject! as [String : AnyObject])
                    self.canciones.append(cancion)
                    
                    //asignación a song para el guardado en BBDD
                    if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
                        let context = container.viewContext
                        self.song = (NSEntityDescription.insertNewObject(forEntityName: "Song", into: context) as? Song)!
                        self.song.trackId = cancion.trackId
                        self.song.trackName = cancion.trackName
                        self.song.collectionCensoredName = cancion.collectionCensoredName
                        self.song.country = cancion.country
                        do {
                            try context.save()
                        }
                        catch{
                            print("error en el save \(error)")
                        }
                    }
                }
            case .failure(let error):
                print(error) // en caso de que falle nos da el error
            }
        }
    }
}

//Configuración en caso de modificación de la tabla
extension TableViewController : NSFetchedResultsControllerDelegate {
    //start
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    //casos
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath{
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath{
                self.tableView.moveRow(at: indexPath, to: newIndexPath)
            }
            
        //si pongo todos no se ejecuta nunca
        default:
            self.tableView.reloadData()
        }
        
        self.songs = controller.fetchedObjects as! [Song]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
