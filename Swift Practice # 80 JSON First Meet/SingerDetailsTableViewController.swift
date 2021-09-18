//
//  SingerDetailsTableViewController.swift
//  Swift Practice # 80 JSON First Meet
//
//  Created by Dogpa's MBAir M1 on 2021/9/18.
//

import UIKit

class SingerDetailsTableViewController: UITableViewController {
    
    //建立歌手API的隨機網址Array
    var singerArray = [
        "https://itunes.apple.com/search?term=周杰倫&media=music",
        "https://itunes.apple.com/search?term=五月天&media=music",
        "https://itunes.apple.com/search?term=梁靜茹&media=music",
        "https://itunes.apple.com/search?term=蘇打綠&media=music",
        "https://itunes.apple.com/search?term=蕭煌奇&media=music"]
    
    //指派變數singerDataFromASA為自定義[SingerDetails]()字串格式
    var singerDataFromASA = [SingerDetails]()
    

    //自定義func取得JSON資料
    func getDetailsFromASA () {
        
        //singerArray洗牌
        singerArray.shuffle()
        //指派urlFromArray為洗牌完後的singerArray第一個值
        let urlFromArray = singerArray[0]
        //因為網址有中文透過if let 指派 urlString 取得剛剛取得的urlFromArray轉碼網址
        if let urlString = urlFromArray.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            //透過 if let 指派JSONUrl為URL類別的網址
            if let JSONUrl = URL(string: urlString){
                //透過URLSession將剛剛指派完成的JSONUrl轉型取得資料
                URLSession.shared.dataTask(with: JSONUrl) { data, response, error in
                    //指派data為DATA類別
                    if let date = data {
                        //將decoder指派為JSONDecoder()
                        let decoder = JSONDecoder()
                        //透過.dateDecodingStrategy取得日期格式為iso8601
                        decoder.dateDecodingStrategy = .iso8601
                        //使用do catch來指派searchResponse為date解碼後的SearchResponse自身
                        //而將指派為自定義型別的singerDataFromASA的資料來源透過
                        //指派完成的searchResponse的.results來取得資料使用
                        do {
                            let searchResponse = try decoder.decode(SearchResponse.self, from: date)
                            self.singerDataFromASA = searchResponse.results
                            //透過主執行緒來重置 self.tableView
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }catch{
                            //若無法do或是失敗列印失敗原因
                            print(error)
                        }
                    }
                }.resume()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //執行自定義getDetailsFromASA()
        getDetailsFromASA()
    }

    // MARK: - Table view data source

    //TableViewSection數量
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //row的數量透過singerDataFromASA透過JSON抓到的網路數量來指派
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return singerDataFromASA.count
    }

    //TableView顯示內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //指派Cell為轉型SingerNameAndPhotoTableViewCell內的"singerDetailsCell"這個Table View
        let cell = tableView.dequeueReusableCell(withIdentifier: "singerDetailsCell", for: indexPath) as! SingerNameAndPhotoTableViewCell
        //指派item為自定義的 singerDataFromASA[indexPath.row]（取得每一列）
        let item = singerDataFromASA[indexPath.row]
        
        //歌手Label與歌名Label的字串指派為artistName與trackName
        cell.singerNameLabel.text = item.artistName
        cell.songNameLabel.text = item.trackName
        
        //因為照片是URL格式，所以在Table再次執行從網路上抓資料取得照片後再指派給songAlbumImageView
        URLSession.shared.dataTask(with: item.artworkUrl100) { data, response , error in
        if let data = data {
            DispatchQueue.main.async {
                cell.songAlbumImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        
        //回傳cell
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
