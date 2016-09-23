import UIKit
import Whisper

class TableViewController: UITableViewController {

  static let reusableIdentifier = "TableViewControllerReusableCell"

  let colors = [
    UIColor(red:1, green:0.67, blue:0.82, alpha:1),
    UIColor(red:0.69, green:0.96, blue:0.4, alpha:1),
    UIColor(red:0.29, green:0.95, blue:0.63, alpha:1),
    UIColor(red:0.31, green:0.74, blue:0.95, alpha:1),
    UIColor(red:0.47, green:0.6, blue:0.13, alpha:1),
    UIColor(red:0.05, green:0.17, blue:0.21, alpha:1),
    UIColor(red:0.9, green:0.09, blue:0.44, alpha:1)]

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.white

    tableView.register(UITableViewCell.self,
      forCellReuseIdentifier: TableViewController.reusableIdentifier)
    tableView.separatorStyle = .none
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard let navigationController = navigationController else { return }
    let message = Message(title: "This message will silent in 3 seconds.", backgroundColor: UIColor(red:0.89, green:0.09, blue:0.44, alpha:1))

    Whisper.show(whisper: message, to: navigationController, action: .present)
    hide(whisperFrom: navigationController, after: 3)
  }

  // MARK: - TableView methods

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 50
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewController.reusableIdentifier)
      else { return UITableViewCell() }

    let number = Int(arc4random_uniform(UInt32(colors.count)))
    cell.backgroundColor = colors[number]
    cell.selectionStyle = .none

    return cell
  }
}
