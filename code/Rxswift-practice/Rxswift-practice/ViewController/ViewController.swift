import UIKit
import RxSwift
import SnapKit
import RxCocoa
import Then

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private let inputTextField = UITextField().then {
        $0.layer.borderWidth = 0.3
        $0.layer.cornerRadius = 3
    }
    
    private let outputLable = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 50)
        $0.textColor = UIColor.black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setAction()
    }
    
    override func viewDidLayoutSubviews() {
        addsubview()
        makeConstraints()
    }
    
    private func addsubview() {
        [
            inputTextField,
            outputLable
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setAction() {
        inputTextField.rx.text.changed
            .bind { value in
                self.outputLable.text = value
            }
            .disposed(by: disposeBag)
    }
    
    private func makeConstraints() {
        inputTextField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
        }
        
        outputLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(inputTextField.snp.bottom).offset(10)
        }
    }
}

