//
//   AstronomyPictureViewModel.swift
//  Space
//
//  Created by Preeteesh Remalli on 07/09/21.
//

import Foundation
struct  AstronomyPictureViewModel {
    let picture : AstronomyPictureModel
    init(_ picture: AstronomyPictureModel){
        
        self.picture = picture
    }
    var title: String{
        return picture.title ?? ""
    }
    var url: String{
        return picture.url ?? ""
    }
    var media_type: String{
        return picture.media_type ?? ""
    }
    var hdurl: String{
        return picture.hdurl ?? ""
    }
    var explanation: String{
        return picture.explanation ?? ""
    }
    var date: String{
        return picture.date ?? ""
    }
    var copyright: String{
        return picture.copyright ?? ""
    }
    var picImage: Data?{
        
        guard let urlString = picture.url else {
            return nil
        }
        guard let url = URL(string: urlString) else{
            return nil
        }
        var picData = Data()
            if let picDat = try? Data(contentsOf: url){
                picData = picDat
            }
        return picData
    }
}

struct AstronomyPictureListViewModel{
    let pictures : [AstronomyPictureViewModel]?
    func pictureAtIndex(_ index: Int) -> AstronomyPictureViewModel{
        return pictures![index]
    }
    func totalPictures() -> Int?{
        return pictures?.count
    }
}
struct AstronomyServiceCall{
    func getPictureOfTheDay(date: String,completion: @escaping (AstronomyPictureViewModel?)->()){
        
        let resource = Resource<AstronomyPictureModel>(url: URL(string: "https://api.nasa.gov/planetary/apod?date=\(date)&api_key=O4sZ0gs9xr7SreUpOiFB4kme2Qm2k1IHZaI58pbP")!)
        WebService().load(resource: resource) { (result) in
            switch result{
            case .success(let weatherResult):
                completion(AstronomyPictureViewModel(weatherResult))
            case .failure(let error):
                completion(nil)
                print(error)
            }
        }
    }
    
    func getPictures(completion: @escaping (AstronomyPictureListViewModel)->()){
        let resource = Resource<[AstronomyPictureModel]>(url: URL(string: "https://api.nasa.gov/planetary/apod?start_date=2021-08-01&end_date=2021-09-05&api_key=O4sZ0gs9xr7SreUpOiFB4kme2Qm2k1IHZaI58pbP")!)
        WebService().load(resource: resource) { (result) in
            switch result{
            case .success(let weatherResult):
                let result  = weatherResult.map { APModel in
                    AstronomyPictureViewModel(APModel)
                }
                completion(AstronomyPictureListViewModel(pictures: result))
            case .failure(let error):
                print(error)
            }
        }
    }
}
