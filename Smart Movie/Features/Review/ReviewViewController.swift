//
//  ReviewViewController.swift
//  Smart Movie
//
//  Created by Phuong on 24/04/2022.
//

import UIKit

final class ReviewViewController: UIViewController {

    private var presenter = ReviewPresenter(model: ReviewModel())
    var idMovie: Int = 0
    var vote: Int = 0
    
    @IBOutlet private weak var reviewTableView: UITableView!
    @IBOutlet private weak var contentTextField: UITextField!
    @IBOutlet var startVoteImageView: [UIImageView]!
    @IBOutlet var startVoteButton: [UIButton]!
    
    private var listReview: [ResponseReviewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        presenter.fetchReview(id: idMovie)
        
        setupTableView()
        fetchReview()
        
    }
    
    func setupTableView() {
        reviewTableView.dataSource = self
        reviewTableView.delegate = self
        
        reviewTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
    }
    
    private func fetchReview() {
        UsersAPIFetcher.share.fetchReview() {
            result in
                switch result {
                case .success(let json):
                    guard let json = json else {
                        return
                    }
                    print(self.idMovie)
                    for item in (json as! [ResponseReviewModel]) {
                        if item.idMovie == self.idMovie {
                            self.listReview.append(item)
                        }
                        let idUser = UserDefaults.standard.string(forKey: idUser)
                        if item.idUser.elementsEqual(idUser ?? "") && item.idMovie == self.idMovie {
                            for button in self.startVoteButton {
                                button.isEnabled = false
                            }
                            self.showStart(voteAverage: item.vote)
                        } 
                    }
                    self.reviewTableView.reloadData()
                case .failure(let err):
                    print(err.localizedDescription)
                }
        }
        
    }
    
    
    @IBAction func invokeBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func invokSendReviewButton(_ sender: UIButton) {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let content = contentTextField.text
        guard let userName = UserDefaults.standard.string(forKey: fullnameUser) else { return }
        let time = "\(day)/\(month)/\(year)"
        let idUser = UserDefaults.standard.string(forKey: idUser) ?? ""
        
        if vote == 0 {
            alertMessage(title: "Hey", message: "Please rate the movie!")
        } else if content == "" {
            alertMessage(title: "Hey", message: "We want to know you are thinking!")
        } else {
            let review: RequestReviewModel = RequestReviewModel(idUser: idUser, idMovie: idMovie, userName: userName, vote: vote, content: content ?? "", time: time)
            UsersAPIFetcher.share.fetchAddReview(review: review) { (isSuccess) in
                if isSuccess {
                    self.listReview.removeAll()
                    self.alertMessage(title: "Yeah", message: "You are comment")
                    self.contentTextField.text = ""
                } else {
                    self.alertMessage(title: "Oops", message: "Check your connect")
                }
            }
            fetchReview()
            reviewTableView.reloadData()
        }
    }
    
    @IBAction func invokeOneStartButton(_ sender: UIButton) {
        vote = 2
        showStart(voteAverage: vote)
    }
    
    @IBAction func invokeSecondStartButton(_ sender: UIButton) {
        vote = 4
        showStart(voteAverage: vote)
    }
    
    @IBAction func invokeThirdStartButton(_ sender: UIButton) {
        vote = 6
        showStart(voteAverage: vote)
    }
    
    @IBAction func invokeFourStartButton(_ sender: UIButton) {
        vote = 8
        showStart(voteAverage: vote)
    }
    
    @IBAction func invokeFiveStartButton(_ sender: UIButton) {
        vote = 10
        showStart(voteAverage: vote)
    }
    
    private func showStart(voteAverage: Int) {
        if voteAverage <= 2 {
            setColorStart(numberStart: 1)
        } else if voteAverage <= 4 {
            setColorStart(numberStart: 2)
        } else if voteAverage <= 6 {
            setColorStart(numberStart: 3)
        } else if voteAverage <= 8 {
            setColorStart(numberStart: 4)
        } else {
            setColorStart(numberStart: 5)
        }
    }
    
    private func setColorStart(numberStart: Int) {
        for indexStar in 0..<numberStart {
            startVoteImageView[indexStar].tintColor = .systemYellow
        }
        for indexStar in numberStart..<5 {
            startVoteImageView[indexStar].tintColor = .systemGray
        }
    }
    
    private func alertMessage(title: String, message: String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
}

extension ReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter.numberOfRowsInSection()
        return listReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell else {
            return UITableViewCell()
        }
//        cell.bindData(data: presenter.cellForRowAt(indexPath: indexPath))
        cell.bindData(data: listReview[indexPath.row])
        return cell
    }
}

extension ReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/6.5
    }
}

extension ReviewViewController: ReviewViewProtocol {
    func refreshView() {
        reviewTableView.reloadData()
    }
}
