//
//  ViewController.swift
//  Traditional_Market
//
//  Created by 염성필 on 2023/09/26.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift
import Toast

final class MapViewController: BaseViewController, UISearchControllerDelegate {
    let realm = try! Realm()
    
    private let mapView = MapView()
    private let marketAPIManager = MarketAPIManager.shared
    private let viewModel = TraditionalMarketViewModel()
    private let realmManager = RealmManager()

    // 사용자가 누른 index 저장
    var selectedSaveIndex: String = ""
    
    // UISearchController 변수 생성
    var searchController: UISearchController!
    
    // resultsTableController 변수 생성
    private var resultsTableController: SearchResultsViewController!
    
    // didSelect or DeSelect를 위한 변수
    var mkAnnotationSearchResult: MKAnnotation!
    
    // mapView range 반경을 위한 변수
    var rangeFilterAnnoation: Results<TraditionalMarketRealm>!
    
    override func loadView() {
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - configureView
    override func configureView() {
        super.configureView()
        setCollectionView()
        setNetwork()
        setSearchController()
        searchResultAnnotation()
        print("파일 경로 : \(self.realm.configuration.fileURL!)")
        viewModel.startLocation.bind {
            // self.setMyRegion(center: $0)
            self.mapView.setMyRegion(center: $0)
        }
        
        self.viewModel.isCurrentLocation.bind { isSelected in
            print("isSelected",isSelected)
            if isSelected {
                self.mapView.locationManger.startUpdatingLocation()
            } else {
                self.mapView.locationManger.stopUpdatingLocation()
                self.mapView.currentLocationButton.tintColor = .black
            }
        }
        
        mapView.locationManger.delegate = self
        mapView.mapBaseView.delegate = self
        
        mapView.completion = { [weak self] isCurrent in
            print("현재 위치로 버튼 : \(isCurrent)")
            guard let self else { return }
            
            switch mapView.locationManger.authorizationStatus {
            case .authorizedAlways:
                if self.viewModel.isCurrentLocation.value {
                    self.mapView.locationManger.startUpdatingLocation()
                } else {
                    self.mapView.locationManger.stopUpdatingLocation()
                    self.mapView.currentLocationButton.tintColor = .black
                }
            case .notDetermined:
                print("123")
                // self.showLocationSettingAlert()
            case .authorizedWhenInUse:
                print("self.viewModel.isCurrentLocation.value",self.viewModel.isCurrentLocation.value)
                self.viewModel.myLocationClickedBtnIsCurrent(isSelected: isCurrent)
             
            case .denied:
                // self.showLocationSettingAlert()
                print("123")
            case .restricted:
                // self.showLocationSettingAlert()
                print("123")
            @unknown default:
                print("어떤것이 추가 될 수 있음")
            }
            
            
        }
        
    }
    /// Search 결과 값 어노테이션 찍기
    func searchResultAnnotation() {
        resultsTableController.completion = { result in
            print("completion : \(result.marketName)")
            
            self.searchController.searchBar.text = result.marketName
            
            //            print("searchController.searchBar.text", self.searchController.searchBar.text ?? "")
            
            self.mapView.setRegionScale(center: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude))
            
            // 현재 위치 핀 찍기
            let annotation = MKPointAnnotation()
            annotation.title = result.marketName
            annotation.coordinate = CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude)
            self.mkAnnotationSearchResult = annotation
            self.mapView.mapBaseView.addAnnotation(annotation)
            self.mapView.mapBaseView.selectAnnotation(annotation, animated: true)
            
            
            
            let detailVC = DetailViewController()
            // Realm 필터를 사용해서 Item 하나만 던져주기
            detailVC.selectedMarket = self.viewModel.selectedMarketInfomation(location: CLLocationCoordinate2D(latitude: result.latitude, longitude: result.longitude))
            detailVC.isLikeClickedEvent()
            self.present(detailVC, animated: true)
        }
        
    }
    
    /// SearchController 셋팅
    func setSearchController() {
        
        resultsTableController = SearchResultsViewController()
        searchController = UISearchController(searchResultsController: resultsTableController)
        
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        
       // searchController.searchBar.showsCancelButton = true
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "시장 지도"
        self.navigationController?.navigationBar.backgroundColor = .white
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
 
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            viewModel.startLocationFetch(location: location)
            print("시작 위치를 받아오고 있습니다 \(location)")
            mapView.currentLocationButton.tintColor = .systemBlue
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치를 받아오지 못했을때 - \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("위치 권한이 바뀔때 마다 호출 - ")
        // checkDeviceLocationAuthorization()
        mapView.checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard let region = region as? CLCircularRegion else { return }
        // 37.499052 , 127.150779
        print("didEnterRegion - \(region.identifier) 해당 지역에 들어왔습니다.")
        
        // toast presented with multiple options and with a completion closure
        self.mapView.mapBaseView.makeToast("마이페이지에 저장하기", duration: 6.0, position: .bottom, title: "\(region.identifier)") { didTap in
            if didTap {
                print("completion from tap")
                let stampVC = StampViewController()
                stampVC.selectedMarket = self.viewModel.selectedMarketInfomation(location: region.center)
                stampVC.enterStampMethod = .toast
                let nav = UINavigationController(rootViewController: stampVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            } else {
                print("completion without tap")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // 37.500102 , 127.150779
        guard let region = region as? CLCircularRegion else { return }
        print("didExitRegion - \(region.identifier) 해당 지역에서 나갔습니다.")
        
    }
    
    
    // Geofencing Error 처리
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        guard let region = region else {
            print("지역을 모니터링할 수 없으며, 실패 원인을 알 수 없습니다.")
            return
        }
        print("식별자를 사용하여 지역을 모니터링하는 동안 오류가 발생했습니다: \(region.identifier)")
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 현재 위치 표시(점)도 일종에 어노테이션이기 때문에, 이 처리를 안하게 되면, 유저 위치 어노테이션도 변경 된다.
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        switch annotation {
        case is CustomAnnotation:
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
            view.clusteringIdentifier = String(describing: CustomAnnotationView.self)
            return view
        case is MKClusterAnnotation:
            return mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: annotation)
        default:
            return nil
        }
        
        //  return annotationView
    }
    
    // MapView를 터치했을때 액션 메서드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mapView.locationManger.stopUpdatingLocation()
        mapView.currentLocationButton.isSelected = false
        mapView.currentLocationButton.tintColor = .black
    }
    
    // 어노테이션을 클릭했을때 액션 메서드
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        //  -> 축척이 변함 -> dismiss  ->  present -> regionDidChangeAnimated -> mapViewRangeInAnnotations -> mapView.mapBaseView.removeAnnotations -> 선택된 Annotation 자동으로 해제 -> didDeselect
        print("찍힌 어노테이션 : \(annotation.title!!)")
        
        // 내 위치 클릭했을때 DetailVC 띄우지 않기
        guard !annotation.isKind(of: MKUserLocation.self) else { return }
        
        let detailVC = DetailViewController()
        // Realm 필터를 사용해서 Item 하나만 던져주기
        detailVC.selectedMarket = viewModel.selectedMarketInfomation(location: annotation.coordinate)
        detailVC.isLikeClickedEvent()
        self.dismiss(animated: true) {
            self.present(detailVC, animated: true)
            //   self.setRegionScale(center: annotation.coordinate)
            self.mapView.setRegionScale(center: annotation.coordinate)
        }
    }
    
    
    
    
    
    // 핀을 터치 하지 않았을때 present된 DetailVC 내려주기
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        //  dismiss(animated: true)
        print("didDeselect")
    }
    
    // MapView Zoom의 거리 확인
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let span = mapView.region.span
        let center = mapView.region.center
        
        let farSouth = CLLocation(latitude: center.latitude - span.latitudeDelta * 0.5, longitude: center.longitude)
        let farNorth = CLLocation(latitude: center.latitude + span.latitudeDelta * 0.5, longitude: center.longitude)
        let farEast = CLLocation(latitude: center.latitude, longitude: center.longitude + span.longitudeDelta * 0.5)
        let farWest = CLLocation(latitude: center.latitude, longitude: center.longitude - span.longitudeDelta * 0.5)
        
        let minimumLatitude: Double = farSouth.coordinate.latitude as Double
        let maximumLatitude: Double = farNorth.coordinate.latitude as Double
        let minimumlongtitude: Double = farWest.coordinate.longitude as Double
        let maximumLongitude: Double = farEast.coordinate.longitude as Double
        
        
        rangeFilterAnnoation = realmManager.mapViewRangeFilterAnnotations(minLati: minimumLatitude, maxLati: maximumLatitude, minLong: minimumlongtitude, maxLong: maximumLongitude)
        print("MapView 반경에 있는 총 갯수:",rangeFilterAnnoation.count)
        
        
        if self.mapView.authorization == .authorizedWhenInUse || self.mapView.authorization == .authorizedAlways || self.mapView.authorization == .denied {
            
            if self.mapView.selectedCell != nil {
                //   filterCityAnnotation()
                self.mapView.filterCityAnnotation(filterMarket: rangeFilterAnnoation)
            } else { // selectedCell == nil 이라면
                //  mapViewRangeInAnnotations(containRange: rangeFilterAnnoation)
                self.mapView.mapViewRangeInAnnotations(containRange: rangeFilterAnnoation)
            }
        }
        
    }
}

// MARK: - UICollectionViewDelegate
extension MapViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        mapView.mapBaseView.removeAnnotations(mapView.mapBaseView.annotations)
        let data = mapView.cityList[indexPath.item]
        // CollectionView에서 해당 indexPath를 사용해서 Cell 뽑아내기
        let aa = mapView.collectionView.cellForItem(at: indexPath) as! CityCell
        // Cell을 선택했다면 그 전의 Cell 배경색 white로 변경하기
        
        if selectedSaveIndex == "\(indexPath.item)" {
            self.mapView.selectedCell = nil
            selectedSaveIndex = ""
            // self.mapViewRangeInAnnotations(containRange: rangeFilterAnnoation)
            self.mapView.mapViewRangeInAnnotations(containRange: rangeFilterAnnoation)
            aa.baseView.backgroundColor = .white
        } else {
            if !selectedSaveIndex.isEmpty {
                let bb = mapView.collectionView.cellForItem(at: IndexPath(row: Int(selectedSaveIndex)!, section: 0)) as! CityCell
                bb.baseView.backgroundColor = .white
            }
            selectedSaveIndex = "\(indexPath.item)"
            self.mapView.selectedCell = data.localname
            aa.baseView.backgroundColor = .yellow
        }
        print("\(indexPath.item) 인덱스 상세 조건: \( self.mapView.selectedCell ?? "nil입니다.")")
        // filterCityAnnotation()
        self.mapView.filterCityAnnotation(filterMarket: rangeFilterAnnoation)
    }
}


// MARK: - UICollectionViewDataSource
extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapView.cityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CityCell.self), for: indexPath) as? CityCell else { return UICollectionViewCell() }
        let data = mapView.cityList[indexPath.item]
        cell.imageView.image = UIImage(named: data.imageName)
        cell.localName.text = data.localname
        return cell
    }
}


extension MapViewController {
    
    fileprivate func setNetwork() {
        // 전통시장 API에서 데이터 불러오기
        marketAPIManager.request { item in
            print("네트워크에서 저장한 RealmAdd하고 데이터 가져오기")
        }
    }
    
    fileprivate func setCollectionView() {
        mapView.collectionView.delegate = self
        mapView.collectionView.dataSource = self
    }

}

// MARK: - UISearchBarDelegate
extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let mkAnnotationSearchResult {
            print("어떤게 적용됐나?",mkAnnotationSearchResult.title!!)
            dismiss(animated: true)
        }
    }
    
    
    
    func presentSearchController(_ searchController: UISearchController) {
        print("presentSearchController")
        mapView.locationManger.stopUpdatingLocation()
        mapView.currentLocationButton.tintColor = .black
        // 검색창 실행시 DetailVC 내리기
        dismiss(animated: true)
    }
}


// MARK: - UISearchResultsUpdating
extension MapViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        let filterResults = realmManager.searchFilterData(text: text)
        // 검색 결과 SearchResultsVC로 전달 및 tableView Reload하기
        if let resultsController = searchController.searchResultsController as? SearchResultsViewController {
            resultsController.filterData = filterResults
            resultsController.tableView.reloadData()
            
        }
    }
}
