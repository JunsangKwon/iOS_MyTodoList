//
//  ViewController.swift
//  MyTodoList
//
//  Created by 권준상 on 2021/01/30.
//

import UIKit

class TodoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let todoViewModel = TodoViewModel();
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var inputTextBottom: NSLayoutConstraint!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    //Num of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoViewModel.numOfTodoList
    }
    
    //Custom Cell 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
            return UICollectionViewCell()
        }
        var todo = todoViewModel.todos[indexPath.item]
        cell.updateUI(todo: todo)
        
        cell.doneButtonTapHandler = { isDone in
            todo.isDone = isDone
            self.todoViewModel.updateTodo(todo)
            self.collectionView.reloadData()
        }
        
        cell.deleteButtonTapHandler = {
            self.todoViewModel.deleteTodo(todo: todo)
            self.collectionView.reloadData()
        }
        
        
        return cell
    }
    
    //Custom Header 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else {
            return UICollectionReusableView()
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = collectionView.bounds.width
        let height:CGFloat = 50
        return CGSize(width: width, height: height)
    }
    

    @IBAction func addButtonClick(_ sender: Any) {
        guard let detail = inputTextField.text, detail.isEmpty==false else {
            return
        }
        let todo = todoViewModel.createTodo(detail: detail)
        todoViewModel.addTodo(todo: todo)
        collectionView.reloadData()
        inputTextField.text = ""
    }
    
    @IBAction func tabBG(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
    
}

extension TodoViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom // 아이폰 노치의 높이
            print(adjustmentHeight)
            inputTextBottom.constant = adjustmentHeight
        } else {
            inputTextBottom.constant = 0
        }
    }
}

class TodoListCell: UICollectionViewCell {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var strikeThroughView: UIView!
    @IBOutlet weak var strikeThroughWidth: NSLayoutConstraint!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    func updateUI(todo: Todo) {
        checkButton.isSelected = todo.isDone
        descriptionLabel.text = todo.detail
        descriptionLabel.alpha = todo.isDone ? 0.2 : 1
        deleteButton.isHidden = todo.isDone == false
        showStrikeThrough(todo.isDone)
    }
    
    func showStrikeThrough(_ isDone: Bool) {
        if(!isDone) {
            strikeThroughWidth.constant = 0
        } else {
            strikeThroughWidth.constant = descriptionLabel.bounds.width
        }
    }
    
    func reset() {
        checkButton.isSelected = false
        deleteButton.isHidden = true
        showStrikeThrough(false)
    }
    
    @IBAction func checkButtonClick(_ sender: Any) {
        checkButton.isSelected = !checkButton.isSelected
        let isDone = checkButton.isSelected
        showStrikeThrough(isDone)
        descriptionLabel.alpha = isDone ? 0.2 : 1
        deleteButton.isHidden = !isDone
        
        doneButtonTapHandler?(isDone)
    }
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        deleteButtonTapHandler?()
    }
    
}

class TodoListHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var sectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
