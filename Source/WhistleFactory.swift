import UIKit

Whistle()

public class Whistle: UIView {

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    return label
    }()

  public override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(titleLabel)
  }

  public func configureWhistle() {
    
  }
}
