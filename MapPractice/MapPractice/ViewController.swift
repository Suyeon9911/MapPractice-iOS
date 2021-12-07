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

    // 위도, 경도, 범위 -> 원하는 위치 표시하는 함수
    private func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) {
        // 위도 값과 경도 값을 매개변수
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        // 범위 값을 매개변수로
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mapView.setRegion(pRegion, animated: true)
    }

    // 위치가 없데이트 되었을 때 지도에 위치를 나타내기 위한 함수
    private func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치가 업데이트 되면 먼저 마지막 위치 값을 찾아냄
        let pLocation = locations.last
        /// 마지막 위치의 위도와 경도 값을 가지고 앞에서 만든 goLocation 함수 호출
        /// delta 값은 지도의 크기. 값이 작을수록 확대되는 효과가 있음. 100배 확대 
        goLocation(latitudeValue: (pLocation?.coordinate.latitude)! , longitudeValue: (pLocation?.coordinate.longitude)! , delta: 0.01 )

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

