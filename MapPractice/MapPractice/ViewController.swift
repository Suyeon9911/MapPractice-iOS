//
//  ViewController.swift
//  MapPractice
//
//  Created by 김수연 on 2021/12/07.
//

import UIKit
import MapKit

import SnapKit
import Then

class ViewController: UIViewController {

    let items = ["현재위치", "우리집", "숭실대학교"]
    let locationManager = CLLocationManager()

    private lazy var locationSegment = UISegmentedControl(items: items).then {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(segChanged(seg: )), for: UIControl.Event.valueChanged)
    }

    private lazy var mapView = MKMapView().then {
        // 위치보기값을 true 로 설정
        $0.showsUserLocation = true
    }

    private let titleLabel = UILabel().then {
        $0.text = "어떤위치"
        $0.font = .systemFont(ofSize: 12)
    }

    private let locationLabel = UILabel().then {
        $0.text = "위치정보"
        $0.font = .systemFont(ofSize: 12)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayouts()
        setDelegation()
        setMap()
    }

}

extension ViewController {
    func setDelegation() {
        locationManager.delegate = self
    }
    func setMap() {
        // 정확도를 최고로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 데이터를 추적하기 위해 사용자에게 승인요청
        locationManager.requestWhenInUseAuthorization()
        // 위치업데이트 시작
        locationManager.startUpdatingLocation()
    }
}

extension ViewController {
    @objc func segChanged(seg: UISegmentedControl) {

    }
}

// Delegate
extension ViewController: CLLocationManagerDelegate {

}

extension ViewController {
    func setLayouts() {
        setViewHierarchies()
        setConstraints()
    }

    func setViewHierarchies() {
        view.addSubview(locationSegment)
        view.addSubview(mapView)
        view.addSubview(titleLabel)
        view.addSubview(locationLabel)
    }

    func setConstraints() {
        locationSegment.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(50)
        }

        mapView.snp.makeConstraints{
            $0.top.equalTo(locationSegment.snp.bottom).inset(-10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(mapView.snp.bottom).inset(-10)
            $0.leading.equalTo(mapView.snp.leading).inset(0)
        }
        locationLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).inset(-10)
            $0.leading.equalTo(mapView.snp.leading).inset(0)
            $0.bottom.equalToSuperview().offset(-50)
        }
    }
}

