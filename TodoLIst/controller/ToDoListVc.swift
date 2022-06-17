//
//  ToDoListVc.swift
//  TodoLIst
//
//  Created by Monika Piątkowska on 14/06/2022.
//

import UIKit

class ToDoListVc: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tasks: [ToDoItem] = []

    override func viewWillAppear(_ animated: Bool) {
        reloadTable()
    }
    
    @IBAction func addOnClick(_ sender: Any) {
        addItem()
    }
    
    
    func addItem() {
        let ac = UIAlertController(title: "Co masz do zrobienia?", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let saveAction = UIAlertAction(title: "Dodaj", style: .default) { [unowned ac] _ in
            if let text = ac.textFields![0].text {
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                ToDoRepository.shared.add(text: text, context: appDelegate.persistentContainer.viewContext)
                self.reloadTable()
            }
        }
        ac.addAction(saveAction)
        ac.addAction(UIAlertAction(title: "Anuluj", style: .cancel, handler: { (_) in}))
        present(ac, animated: true)
    }
    
    private func reloadTable() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        tasks = ToDoRepository.shared.getAll(context: appDelegate.persistentContainer.viewContext).sorted { $0.id < $1.id }
        self.tableView.reloadData()
    }
}

extension ToDoListVc: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoListItem", for: indexPath) as! TodoTableViewCell

        cell.setTitle(data: tasks[indexPath.row])
        return cell
    }
}

extension ToDoListVc: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDoItem = tasks[indexPath.row]
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        ToDoRepository.shared.toogleStatus(item: toDoItem, context: appDelegate.persistentContainer.viewContext)
        reloadTable()
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive,
                                       title: "Usuń") { [weak self] (action, view, completionHandler) in
                                        self?.handleMoveToTrash(indexPath)
                                        completionHandler(true)
        }
        trash.backgroundColor = .systemRed

        let unread = UIContextualAction(style: .normal,
                                       title: "Edycja") { [weak self] (action, view, completionHandler) in
                                        self?.handleEdit(indexPath)
                                        completionHandler(true)
        }
        unread.backgroundColor = .systemOrange

        let configuration = UISwipeActionsConfiguration(actions: [trash, unread])

        return configuration
    }
    
    private func handleMoveToTrash(_ indexPath: IndexPath) {
                        let toDoItem = tasks[indexPath.row]
                        guard let appDelegate =
                            UIApplication.shared.delegate as? AppDelegate else {
                            return
                        }
                        ToDoRepository.shared.delete(item: toDoItem, context: appDelegate.persistentContainer.viewContext)
                        reloadTable()
    }
    
    private func handleEdit(_ indexPath: IndexPath) {
        let todoItem = tasks[indexPath.row]
        editItem(todoItem: todoItem)
    }
    private func editItem(todoItem: ToDoItem) {
        let ac = UIAlertController(title: "Edytuj zadanie", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].text = todoItem.text

        let saveAction = UIAlertAction(title: "Zapisz", style: .default) { [unowned ac] _ in
            if let text = ac.textFields![0].text {
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                var todoItem = todoItem
                todoItem.text = text
                ToDoRepository.shared.edit(todoItem: todoItem, context: appDelegate.persistentContainer.viewContext)
                self.reloadTable()
            }
        }
        ac.addAction(saveAction)
        ac.addAction(UIAlertAction(title: "Anuluj", style: .cancel, handler: { (_) in}))
        present(ac, animated: true)
    }
}
