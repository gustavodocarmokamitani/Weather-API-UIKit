//
//  ViewController.swift
//  Weather App
//
//  Created by Gustavo Kamitani on 11/06/24.
//

import UIKit

class ViewController: UIViewController {
    var bg = "background"
    var pColor = "primaryColor"
    var sunIcon = "sunIcon"
    
    private lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: bg)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.contrasctColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = UIColor.primaryColor
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.primaryColor
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: sunIcon)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var detailTemperatureView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.primaryColor
        view.layer.cornerRadius = 20
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.5
        
        
        return view
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Umidade"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.contrasctColor
        return label
    }()
    
    private lazy var valueHumidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .right
        label.textColor = UIColor.contrasctColor
        return label
    }()
    
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vento"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .left
        label.textColor = UIColor.contrasctColor
        return label
    }()
    
    private lazy var valueWindLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .right
        label.textColor = UIColor.contrasctColor
        return label
    }()
    
    private lazy var hourlyForecastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Previsão por Hora".uppercased()
        label.textAlignment = .center
        label.textColor = UIColor.contrasctColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var hourlyCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 67, height: 84)
            layout.sectionInset = UIEdgeInsets(top: 0,
                                               left: 12,
                                               bottom: 0,
                                               right: 12)
            let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.register(HourlyForecastCollectionViewCell.self,
                                    forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.indentifier)
            collectionView.showsHorizontalScrollIndicator = false
            return collectionView
    }()
    
    private lazy var dailyForecastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PRÓXIMOS DIAS".uppercased()
        label.textAlignment = .center
        label.textColor = UIColor.contrasctColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private lazy var dailyForecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.indentifier)
        return tableView
    }()
    
    private let service = Service()
    
    private var city = City(lat: "-23.6814346", lon: "-46.9249599", name: "São Paulo")
    private var forecastResponse: ForecastResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        detailTemperatureView.addShadow(radius: 10, color: .black,  offset: CGSize(width: -1, height: 1), opacity: 0.25)
        
        fetchData()
    }
    
    private func fetchData() {
        service.fecthData(city: city) { [weak self] response in
            self?.forecastResponse = response
            DispatchQueue.main.async {
                self?.loadData()
            }
        }
    }
    
    private func loadData(){
        cityLabel.text = city.name
        
        temperatureLabel.text = forecastResponse?.current.temp.toCelsius()
        valueHumidityLabel.text = "\(forecastResponse?.current.humidity ?? 0)mm"
        valueWindLabel.text = "\(forecastResponse?.current.humidity ?? 0)km/h"
    
        hourlyCollectionView.reloadData()
        dailyForecastTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupView() {
        view.backgroundColor = .red
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        view.addSubview(backgroundView)
        
        view.addSubview(headerView)
        headerView.addSubview(cityLabel)
        headerView.addSubview(temperatureLabel)
        headerView.addSubview(weatherIcon)
        
        view.addSubview(detailTemperatureView)
        detailTemperatureView.addSubview(humidityLabel)
        detailTemperatureView.addSubview(windLabel)
        detailTemperatureView.addSubview(valueHumidityLabel)
        detailTemperatureView.addSubview(valueWindLabel)
        
        view.addSubview(hourlyForecastLabel)
        
        view.addSubview(hourlyCollectionView)
        
        view.addSubview(dailyForecastLabel)				
        view.addSubview(dailyForecastTableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            headerView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            cityLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            cityLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            cityLabel.heightAnchor.constraint(equalToConstant: 20),
            
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 12),
            temperatureLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 18),
            
            weatherIcon.heightAnchor.constraint(equalToConstant: 86),
            weatherIcon.widthAnchor.constraint(equalToConstant: 86),
            weatherIcon.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 15),
            weatherIcon.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -18),
            weatherIcon.centerYAnchor.constraint(equalTo: temperatureLabel.centerYAnchor),
            weatherIcon.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 8)
            
        ])
        
        NSLayoutConstraint.activate([
            detailTemperatureView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            detailTemperatureView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            detailTemperatureView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            detailTemperatureView.heightAnchor.constraint(equalToConstant: 85),
            
            humidityLabel.topAnchor.constraint(equalTo: detailTemperatureView.topAnchor, constant: 20),
            humidityLabel.leadingAnchor.constraint(equalTo: detailTemperatureView.leadingAnchor, constant: 25),
            humidityLabel.trailingAnchor.constraint(equalTo: detailTemperatureView.trailingAnchor, constant: -50),
            
            windLabel.bottomAnchor.constraint(equalTo: detailTemperatureView.bottomAnchor, constant: -20),
            windLabel.leadingAnchor.constraint(equalTo: detailTemperatureView.leadingAnchor, constant: 25),
            windLabel.trailingAnchor.constraint(equalTo: detailTemperatureView.trailingAnchor, constant: -50),
            
            valueHumidityLabel.topAnchor.constraint(equalTo: detailTemperatureView.topAnchor, constant: 20),
            valueHumidityLabel.trailingAnchor.constraint(equalTo: detailTemperatureView.trailingAnchor, constant: -25),
            
            valueWindLabel.bottomAnchor.constraint(equalTo: detailTemperatureView.bottomAnchor, constant: -20),
            valueWindLabel.trailingAnchor.constraint(equalTo: detailTemperatureView.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            hourlyForecastLabel.topAnchor.constraint(equalTo: detailTemperatureView.bottomAnchor, constant: 30),
            hourlyForecastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hourlyCollectionView.topAnchor.constraint(equalTo: hourlyForecastLabel.bottomAnchor, constant: 30),
            hourlyCollectionView.heightAnchor.constraint(equalToConstant: 94),
            hourlyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dailyForecastLabel.topAnchor.constraint(equalTo: hourlyCollectionView.bottomAnchor, constant: 29),
            dailyForecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            dailyForecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            dailyForecastTableView.topAnchor.constraint(equalTo: dailyForecastLabel.bottomAnchor, constant: 15),
            dailyForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyForecastTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension UIView {
    func addShadow(radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float) {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastResponse?.hourly.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.indentifier, for: indexPath) as? HourlyForecastCollectionViewCell else {
            return UICollectionViewCell()
        }
        let forecast = forecastResponse?.hourly[indexPath.row]
        
        cell.loadData(time: forecast?.dt.toHourFormat(),
                       icon: UIImage(named: "sunIcon"),
                      temp: forecast?.temp.toCelsius())
        
        return cell
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastResponse?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.indentifier, for: indexPath) as? DailyForecastTableViewCell else {
            return UITableViewCell()
        }
        let forecast = forecastResponse?.daily[indexPath.row]
        cell.loadData(weekDay: forecast?.dt.toWeekdayName().uppercased(), min: forecast?.temp.min.toCelsius(), max: forecast?.temp.max.toCelsius(), icon: UIImage(named: sunIcon))
        return cell
    }
    
    
}
