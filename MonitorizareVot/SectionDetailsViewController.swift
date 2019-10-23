//
//  SectionDetailsViewController.swift
//  MonitorizareVot
//
//  Created by Cristi Habliuc on 28/09/2019.
//  Copyright © 2019 Code4Ro. All rights reserved.
//

import UIKit

class SectionDetailsViewController: MVViewController {
    
    var model: SectionDetailsViewModel

    fileprivate weak var headerViewController: SectionHUDViewController!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var headerContainer: UIView!
    
    @IBOutlet weak var environmentLabel: UILabel!
    @IBOutlet weak var chairmanGenderLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    
    @IBOutlet weak var envUrbanButton: UIButton!
    @IBOutlet weak var envRuralButton: UIButton!
    @IBOutlet weak var genderWomanButton: UIButton!
    @IBOutlet weak var genderManButton: UIButton!
    @IBOutlet weak var arrivalButton: UIButton!
    @IBOutlet weak var departureButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                spinner.startAnimating()
                continueButton.isEnabled = false
            } else {
                spinner.stopAnimating()
                continueButton.isEnabled = true
            }
        }
    }
    
    // MARK: - Object
    
    init(withModel model: SectionDetailsViewModel) {
        self.model = model
        super.init(nibName: "SectionDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Title.StationDetails".localized
        configureSubviews()
        configureHeader()
        bindToUpdates()
        addContactDetailsToNavBar()
        isLoading = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInterface()
    }
    
    // MARK: - Config
    
    fileprivate func bindToUpdates() {
        model.onUpdate = { [weak self] in
            self?.updateInterface()
        }
    }

    fileprivate func configureSubviews() {
    }
    
    fileprivate func configureHeader() {
        let controller = SectionHUDViewController()
        controller.view.translatesAutoresizingMaskIntoConstraints = true
        controller.willMove(toParent: self)
        addChild(controller)
        controller.view.frame = headerContainer.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
        headerViewController = controller
        controller.onChangeAction = { [weak self] in
            self?.handleChangeSectionButtonAction()
        }
    }
    
    // MARK: - UI
    
    fileprivate func updateInterface() {
        envUrbanButton.isSelected = model.medium == .urban
        envRuralButton.isSelected = model.medium == .rural
        genderWomanButton.isSelected = model.gender == .woman
        genderManButton.isSelected = model.gender == .man
        arrivalButton.setTitle(model.arrivalTime ?? "--:--", for: .normal)
        departureButton.setTitle(model.departureTime ?? "--:--", for: .normal)
    }
    
    fileprivate func updateLabelsTexts() {
        environmentLabel.text = "Label_CountyLocation".localized
        envUrbanButton.setTitle("Button_Urban".localized, for: .normal)
        envRuralButton.setTitle("Button_Rural".localized, for: .normal)
        
        chairmanGenderLabel.text = "Label_CountyPresidentGender".localized
        genderWomanButton.setTitle("Button_Female".localized, for: .normal)
        genderManButton.setTitle("Button_Male".localized, for: .normal)
        
        arrivalTimeLabel.text = "Label_CountyArriveTime".localized
        departureTimeLabel.text = "Label_CountyLeaveTime".localized
        
        continueButton.setTitle("Button_ContinueToForms".localized, for: .normal)
    }
    
    // MARK: - Actions
    
    fileprivate func handleChangeSectionButtonAction() {
        // simply take the user back to the section selection screen
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func handleEnvironmentButtonTap(_ sender: UIButton) {
        var medium: SectionInfo.Medium!
        switch sender {
        case envUrbanButton: medium = .urban
        case envRuralButton: medium = .rural
        default: break
        }
        model.medium = medium
    }
    
    @IBAction func handleGenderButtonTap(_ sender: UIButton) {
        var gender: SectionInfo.Genre!
        switch sender {
        case genderWomanButton: gender = .woman
        case genderManButton: gender = .man
        default: break
        }
        model.gender = gender
    }
    
    @IBAction func handleTimeButtonTap(_ sender: UIButton) {
        let isArrivalTime = sender == arrivalButton
        let initialTime = isArrivalTime ? model.arrivalTime : model.departureTime

        let pickerModel = TimePickerViewModel(withTimeString: initialTime ?? "")
        let controller = TimePickerViewController(withModel: pickerModel)
        controller.onCompletion = { [weak self] time in
            if isArrivalTime {
                self?.model.arrivalTime = time
                let departureDate = TimePickerViewModel.timeStringToDate(self?.model.departureTime ?? "")
                if let departure = departureDate,
                    let arrival = pickerModel.date,
                    arrival > departure {
                    // reset the departure to the same time
                    self?.model.departureTime = time
                }
            } else {
                self?.model.departureTime = time
                let arrivalDate = TimePickerViewModel.timeStringToDate(self?.model.arrivalTime ?? "")
                if let arrival = arrivalDate,
                    let departure = pickerModel.date,
                    arrival > departure {
                    // reset the arrival to the same time
                    self?.model.arrivalTime = time
                }
            }
            controller.dismiss(animated: true, completion: nil)
        }
        controller.modalPresentationStyle = .overCurrentContext
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func handleContinueButtonTap(_ sender: Any) {

        // persist the data first
        self.isLoading = true
        model.persist { [weak self] (success, isTokenExpired) in
            guard let self = self else { return }
            self.isLoading = false

            if isTokenExpired {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                let formsModel = FormListViewModel()
                let formsVC = FormListViewController(withModel: formsModel)
                self.navigationController?.pushViewController(formsVC, animated: true)
            }
        }

    }
}
