//
//  PaletteTableViewCell.swift
//  Palette
//
//  Created by William Moody on 6/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {

    var unsplashPhoto: UnsplashPhoto? {
        didSet{
            updateViews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        colorPaletteView.colors = [.orange]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let unsplashPhoto = unsplashPhoto else {return}
        fetchAndSetImage(for: unsplashPhoto)
        fetchAndSetColors(for: unsplashPhoto)
        titleLabel.text = unsplashPhoto.description
    }
    
    func fetchAndSetImage(for unsplashPhoto: UnsplashPhoto) {
        UnsplashService.shared.fetchImage(for: unsplashPhoto) { (image) in
            DispatchQueue.main.async {
                self.paletteImageView.image = image
            }
        }
    }
    
    func fetchAndSetColors(for unsplashPhoto: UnsplashPhoto) {
        ImaggaService.shared.fetchColorsFor(imagePath: unsplashPhoto.urls.regular) { (colors) in
            DispatchQueue.main.async {
                guard let colors = colors else {return}
                self.colorPaletteView.colors = colors
            }
        }
    }
    
    func setUpViews() {
        addAllSubViews()
        let imageWidth = (contentView.frame.width - SpacingConstants.outerHorizontalPadding * 2)
        paletteImageView.anchor(top: contentView.topAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: SpacingConstants.outerVirticalPadding, paddingBottom: 0, paddingLeading: SpacingConstants.outerHorizontalPadding, paddingTrailing: SpacingConstants.outerHorizontalPadding, width: imageWidth, height: imageWidth)
        
        titleLabel.anchor(top: paletteImageView.bottomAnchor, bottom: nil, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: SpacingConstants.verticalObjectBuffer, paddingBottom: 0, paddingLeading: SpacingConstants.outerHorizontalPadding, paddingTrailing: SpacingConstants.outerHorizontalPadding)
        
        colorPaletteView.anchor(top: titleLabel.bottomAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, paddingTop: SpacingConstants.verticalObjectBuffer, paddingBottom: SpacingConstants.outerVirticalPadding, paddingLeading: SpacingConstants.outerHorizontalPadding, paddingTrailing: SpacingConstants.outerHorizontalPadding, width: nil, height: SpacingConstants.twoLineElementHeight)
        
        colorPaletteView.clipsToBounds = true
        colorPaletteView.layer.cornerRadius = (SpacingConstants.twoLineElementHeight / 2)
    }
    
    func addAllSubViews() {
        addSubview(paletteImageView)
        addSubview(titleLabel)
        addSubview(colorPaletteView)
    }

    //subviews
    lazy var paletteImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var colorPaletteView: ColorPaletteView = {
        let paletteView = ColorPaletteView()
        return paletteView
    }()
    
    
}
