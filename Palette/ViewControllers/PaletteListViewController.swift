//
//  PaletteListViewController.swift
//  Palette
//
//  Created by William Moody on 6/11/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PaletteListViewController: UIViewController {

    var photos: [UnsplashPhoto] = []
    
    //setting area to operate app
    var safeArea: UILayoutGuide{
        return self.view.safeAreaLayoutGuide
    }
    var buttons: [UIButton]{
        return [featureButton, randomButton, doubleRainbowButton]
    }
    
    
    //loading all views
    override func loadView() {
        super.loadView()
        addAllSubViews()
        setUpStackView()
        paletteTableView.anchor(top: buttonStackView.bottomAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 8, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureTableView()
        selectButton(featureButton)
        activateButtons()
    }
    
    func addAllSubViews() {
        view.addSubview(featureButton)
        view.addSubview(randomButton)
        view.addSubview(doubleRainbowButton)
        view.addSubview(buttonStackView)
        view.addSubview(paletteTableView)
    }
    
    func setUpStackView() {
        //giving us controll of constraints
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView.addArrangedSubview(featureButton)
        buttonStackView.addArrangedSubview(randomButton)
        buttonStackView.addArrangedSubview(doubleRainbowButton)
        
        /*
        buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        */
        //same as above
        buttonStackView.anchor(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 16, paddingBottom: 0, paddingLeading: 16, paddingTrailing: 16)
    }
    
    func configureTableView() {
        paletteTableView.dataSource = self
        paletteTableView.delegate = self
        paletteTableView.register(PaletteTableViewCell.self, forCellReuseIdentifier: "colorCell")
        paletteTableView.allowsSelection = false
    }
    
    func searchForCategory(_ unsplashedRoute: UnsplashRoute) {
        UnsplashService.shared.fetchFromUnsplash(for: unsplashedRoute) { (unsplashPhotos) in
            guard let unsplashPhotos = unsplashPhotos else {return}
            self.photos = unsplashPhotos
            DispatchQueue.main.async {
                self.paletteTableView.reloadData()
            }
        }
    }
    
    func activateButtons() {
        buttons.forEach{$0.addTarget(self, action: #selector(searchButtonTapped(sender:)), for: .touchUpInside)}
    }
    
    func selectButton(_ button: UIButton) {
        buttons.forEach{$0.setTitleColor(UIColor.lightGray, for: .normal)}
        button.setTitleColor(UIColor(named: "devmountainBlue"), for: .normal)
    }
    
    //MARK: - Views
    
    //buttons
    let featureButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Featured", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Random", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    let doubleRainbowButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Double Rainbow", for: .normal)
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        return button
    }()
    
    //StackView
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    let paletteTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    @objc func searchButtonTapped(sender: UIButton){
        print("tapped")
        selectButton(sender)
        switch sender {
        case featureButton:
            searchForCategory(.featured)
        case randomButton:
            searchForCategory(.random)
        case doubleRainbowButton:
            searchForCategory(.doubleRainbow)
        default:
            print("impossible")
        }
    }
}

extension PaletteListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewSpace: CGFloat = (view.frame.width - (2 * SpacingConstants.outerHorizontalPadding))
        let titleLabelSpace: CGFloat = SpacingConstants.oneLineElementHeight
        let colorPaletteSpace: CGFloat = SpacingConstants.twoLineElementHeight
        let verticalPadding: CGFloat = (3 * SpacingConstants.verticalObjectBuffer)
        let outerVerticalPadding: CGFloat = (2 * SpacingConstants.outerVirticalPadding)
        
        return imageViewSpace + titleLabelSpace + colorPaletteSpace + verticalPadding + outerVerticalPadding
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath) as! PaletteTableViewCell
        
        let unsplashPhoto = photos[indexPath.row]
        
        cell.unsplashPhoto = unsplashPhoto
        
        return cell
    }
    
}
