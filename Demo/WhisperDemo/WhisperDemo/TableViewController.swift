import UIKit
import Whisper

class TableViewController: UITableViewController {

  static let reusableIdentifier = "TableViewControllerReusableCell"

  let colors = [
    UIColor(red:1, green:0.67, blue:0.82, alpha:1),
    UIColor(red:0.69, green:0.96, blue:0.4, alpha:1),
    UIColor(red:0.29, green:0.95, blue:0.63, alpha:1),
    UIColor(red:0.31, green:0.74, blue:0.95, alpha:1)]

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.registerClass(UITableViewCell.self,
      forCellReuseIdentifier: TableViewController.reusableIdentifier)
  }

  // MARK: - TableView methods

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 150
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 50
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier(TableViewController.reusableIdentifier)
      else { return UITableViewCell() }

    let number = Int(arc4random_uniform(UInt32(colors.count)))
    cell.backgroundColor = colors[number]

    return cell
  }
}
