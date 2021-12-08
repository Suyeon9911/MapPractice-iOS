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
        switch seg.selectedSegmentIndex {
        case 0:
            // 현재위치가 표시되도록 레이블 값을 공백으로 초기화
            self.titleLabel.text = ""
            self.locationLabel.text = ""
            locationManager.startUpdatingLocation()
        case 1:
            setAnnotation(latitudeValue: 36.61248, longtitudeValue: 127.48870, delta: 0.01, title: "분평주공 1단지아파트", subtitle: "충청북도 청주시 서원구 월평로25 109동")
            self.titleLabel.text = "보고 있는 위치"
            self.locationLabel.text = "분평주공1단지아파트"
        case 2:
            setAnnotation(latitudeValue: 37.49660, longtitudeValue: 126.95695, delta: 0.01, title: "숭실대학교", subtitle: "서울특별시 동작구 상도로 369")
            self.titleLabel.text = "보고 있는 위치"
            self.locationLabel.text = "숭실대학교"
        default:
            locationManager.startUpdatingLocation()
        }
    }
}

// Delegate
extension ViewController: CLLocationManagerDelegate {

    // 위도, 경도, 범위 -> 원하는 위치 표시하는 함수
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        // 위도 값과 경도 값을 매개변수
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        // 범위 값을 매개변수로
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mapView.setRegion(pRegion, animated: true)

        return pLocation
    }

    // 핀 설치하기
    func setAnnotation(latitudeValue: CLLocationDegrees, longtitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longtitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        mapView.addAnnotation(annotation)
    }

    // 위치가 없데이트 되었을 때 지도에 위치를 나타내기 위한 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치가 업데이트 되면 먼저 마지막 위치 값을 찾아냄
        let pLocation = locations.last
        /// 마지막 위치의 위도와 경도 값을 가지고 앞에서 만든 goLocation 함수 호출
        /// delta 값은 지도의 크기. 값이 작을수록 확대되는 효과가 있음. 100배 확대
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)! , longitudeValue: (pLocation?.coordinate.longitude)! , delta: 0.01)

        /// 위도와 경도 값을 가지고 역으로 위치 정보, 즉 주소 찾기
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            // placemarks의 첫부분만 pm에 저장
            let pm = placemarks!.first
            // pm 상수에서 나라 값을 대입
            let country = pm!.country
            // country 상수를 address 문자열에 대입
            var address:String = country!
            // pm에서 지역 값이 존재하면 address 문자열에 추가
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            // 도로 값이 존재하면 추가
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }

            self.titleLabel.text = "현재 위치"
            self.locationLabel.text = address
        })

        // 위치 없데이트 멈추기
        locationManager.stopUpdatingLocation()
    }

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

