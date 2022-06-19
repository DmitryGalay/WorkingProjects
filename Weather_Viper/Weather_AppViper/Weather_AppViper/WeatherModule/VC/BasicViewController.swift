//
//  WeatherViewController.swift
//  Weather_AppViper
//
//  Created by Dima on 26.01.22.

import UIKit
import SnapKit
import Jelly
import SVProgressHUD

class BasicViewController: UIViewController {
    var timer = Timer()
    let tableView = UITableView()
    var imageView = UIImageView()
    let buttonShowSearch = UIButton()
    var presenter: BasicPresenterInput!
    var basicEntity: BasicEntity?
    let iconsDic = BasicIconsEntity()
    let backgroundEntity = BasicBackgroundEntity()
    var dateFormatterService: DateFormatterService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewIsReady()
        config()
    }
    
    private func config() {
        configTableView()
        configButton()
        createImage()
    }
    
    // MARK: Create and adding tableview
    
    private func configTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        addTableCell()
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: Adding cells for tableview
    
    private func addTableCell() {
        tableView.register(CurrentCell.nib(), forCellReuseIdentifier: CurrentCell.identifier)
        tableView.register(ParamCell.nib(), forCellReuseIdentifier: ParamCell.identifier)
        tableView.register(HourlyCell.nib(), forCellReuseIdentifier: HourlyCell.identifier)
        tableView.register(DailyCell.nib(), forCellReuseIdentifier: DailyCell.indetifier)
    }
    
    // MARK: Create and adding SearchButton
    
    private func configButton() {
        let location = UIImage(systemName: "location.magnifyingglass")
        location?.withTintColor(UIColor.black)
        view.addSubview(buttonShowSearch)
        buttonShowSearch.setBackgroundImage(location, for: .normal)
        buttonShowSearch.tintColor = UIColor(named: "MainColor")
        buttonShowSearch.addTarget(self, action: #selector(showSearch), for: .touchUpInside)
        buttonShowSearch.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.size.equalTo(30)
            make.right.equalToSuperview().inset(30)
        }
    }
    
    // MARK: Adding background image
    
    private func createImage() {
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.center = view.center
        imageView.image = UIImage(named: "broken clouds")
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    private func createBackgroundImage(name: String) {
        imageView.image = UIImage(named: name)
    }
    
    // MARK: Settings for Hourly Cells
    
    private func createHourlyCells(cell: WeekCell, indexPath: IndexPath) {
        let dt = basicEntity?.hourly[indexPath.row ].dt ?? 0
        let dtx = dt + 200.0
        let date = dateFormatterService.dateFormater(dt: dtx, format: "HH")
        let iconName = basicEntity?.hourly[indexPath.row].weather.first?.icon
        for icons in iconsDic.iconsDic {
            if iconName == icons.key {
                let icon = UIImage(systemName: icons.value)?.withRenderingMode(.alwaysOriginal)
                cell.iconWeather.image = icon
            }
        }
        cell.timeLabel.text = date
        cell.tempLabel.text = "\(Int(basicEntity?.hourly[indexPath.row].temp ?? 0))°"
    }
    // MARK: Update Days format
    
    private func createDayOfWeek(indexPath: IndexPath) -> String {
        guard let dt = (basicEntity?.daily[indexPath.row - 1].dt) else { return "" }
        let date = dateFormatterService.dateFormater(dt: dt, format: "EEEE")
        return date
    }
    // MARK: Settings for icon
    
    private func setIcon(indexPath: IndexPath) -> UIImage? {
        let iconName = basicEntity?.daily[indexPath.row - 2].weather[0].icon
        for icons in iconsDic.iconsDic {
            if iconName == icons.key {
                let icon = UIImage(systemName: icons.value)?.withRenderingMode(.alwaysOriginal)
                return icon
            }
        }
        return UIImage(named: "")
    }
    // MARK: Settings for temp
    
    private func setMinTemp(indexPath: IndexPath) -> String {
        let minTemp = "\(Int(basicEntity?.daily[indexPath.row - 2].temp.min ?? 0))°"
        return minTemp
    }
    
    private func setMaxTemp(indexPath: IndexPath) -> String {
        let maxTemp = "\(Int(basicEntity?.daily[indexPath.row - 2].temp.max ?? 0))°"
        return maxTemp
    }
    
    @objc func showSearch() {
        presenter.showSearch()
    }
}
// MARK: Updating tableview data

extension BasicViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = basicEntity?.daily.count ?? 0
        return count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentCell.identifier, for: indexPath) as? CurrentCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            guard let forecast = basicEntity?.hourly else { return UITableViewCell() }
            let daily = forecast[indexPath.row]
            let icon = daily.weather[0].icon
            guard let unwrapIcon = iconsDic.iconsDic[icon] else { return UITableViewCell() }
            cell.iconImageView.image = UIImage(systemName: unwrapIcon)
            cell.cityName.text = basicEntity?.city
            cell.temperatureLabel.text = basicEntity?.temp
            cell.descriptionWeather.text = basicEntity?.descript
            cell.feelsLikeLabel.text = basicEntity?.feelsLike
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ParamCell.identifier, for: indexPath) as? ParamCell else { return UITableViewCell() }
            cell.backgroundColor = UIColor(named: "ParamColor")
            cell.layer.cornerRadius = 25
            cell.humidityLabel.text = basicEntity?.humidity
            cell.windDegLabel.text = basicEntity?.wind_deg
            cell.windLabel.text = basicEntity?.wind
            cell.pressureLabel.text = basicEntity?.pressure
            cell.visibilityLabel.text = basicEntity?.visibility
            cell.sunriseLabel.text = basicEntity?.sunrise
            cell.sunsetLabel.text = basicEntity?.sunset
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HourlyCell.identifier, for: indexPath) as? HourlyCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            
            cell.setTemp = { [weak self] cell, index in
                self?.createHourlyCells(cell: cell, indexPath: index)
            }
            cell.collectionView.reloadData()
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyCell.indetifier, for: indexPath) as? DailyCell else { return UITableViewCell() }
            cell.backgroundColor = UIColor(named: "ParamColor")
            cell.layer.cornerRadius = 25
            cell.dayOfWeekLabel.text = createDayOfWeek(indexPath: indexPath)
            cell.iconImageView.image = setIcon(indexPath: indexPath)
            cell.minTempLabel.text = setMinTemp(indexPath: indexPath)
            cell.maxTempLabel.text = setMaxTemp(indexPath: indexPath)
            cell.slashLabel.text = "/"
            return cell
        }
    }
}

extension BasicViewController: BasicPresenterOutput {
    
    func loadBackground(backgroundName: String) {
        createBackgroundImage(name: backgroundName)
        SVProgressHUD.dismiss()
    }
    
    func createState(with entity: BasicEntity) {
        basicEntity = entity
        tableView.reloadData()
    }
}