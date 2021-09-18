//
//  SingerNameAndPhotoTableViewCell.swift
//  Swift Practice # 80 JSON First Meet
//
//  Created by Dogpa's MBAir M1 on 2021/9/18.
//

import UIKit

class SingerNameAndPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var songAlbumImageView: UIImageView! //專輯封面ImageView
    
    @IBOutlet weak var songNameLabel: UILabel!          //歌曲名稱
    
    @IBOutlet weak var singerNameLabel: UILabel!        //歌手名稱
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
