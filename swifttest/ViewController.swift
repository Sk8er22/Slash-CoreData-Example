//
//  ViewController.swift
//  swifttest
//
//  Copyright © 2017 Slash Mobility S.L. All rights reserved.
//

import UIKit
import CoreData
import CoreGraphics
let kUrl  = "https://itunes.apple.com/search?term=Michael+jackson"

class ViewController: UIViewController {
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {
            let context = container.viewContext
            //creo un thread para lanzar la view del cuadrado
            DispatchQueue.global(qos: .default).async {
                let thread = Thread(target: self, selector: #selector(self.square), object: nil)
                thread.start()
            }
            //Consultamos si hay información en la BBDD
            let request : NSFetchRequest<Song> = NSFetchRequest.init(entityName: "Song")
            do{
                self.songs = try context.fetch(request)
                print("\(songs.count)")
            } catch {
                print("Error en Fetch: \(error)")
            }
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues PASANDO DATOS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let controller = (segue.destination as! UITableViewController) as! TableViewController
            controller.navigationItem.leftItemsSupplementBackButton = true
            if (songs.count == 0)
            {
                controller.request(url: kUrl)
            }
        }
    }
    
    
    //Boton para descargar y simular el uso en main thread
    @IBAction func ButtonSleep(_ sender: UIButton) {
        sleep(10)
    }
    
    
    //generate square view
    func square(){
        let halfSizeOfView = 25.0
        let maxViews = 1
        let insetSize = self.view.bounds.insetBy(dx: CGFloat(Int(2 * halfSizeOfView)), dy: CGFloat(Int(2 * halfSizeOfView))).size
        
        // Add the Views
        for _ in 0..<maxViews {
            let pointX = CGFloat(UInt(arc4random() % UInt32(UInt(insetSize.width))))
            let pointY = CGFloat(UInt(arc4random() % UInt32(UInt(insetSize.height))))
            let newView = SquareView(frame: CGRect(x: pointX, y: pointY, width: 50, height: 50))
            self.view.addSubview(newView)
        }
    }
    
}

