import UIKit

// MARK: - Constraints

extension UIView {
    
    /// Constrains the edges of the view to the edges of its `superview`.
    /// - Note: Does nothing if `self.superview == nil`
    func constrainEdgesToContainer() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint:      NSLayoutConstraint = topAnchor.constraintEqualToAnchor(superview.topAnchor)
        let bottomConstraint:   NSLayoutConstraint = bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor)
        let leftConstraint:     NSLayoutConstraint = leftAnchor.constraintEqualToAnchor(superview.leftAnchor)
        let rightConstraint:    NSLayoutConstraint = rightAnchor.constraintEqualToAnchor(superview.rightAnchor)
        
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    func insetFromContainerEdges(inset: CGFloat) {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint:      NSLayoutConstraint = topAnchor.constraintEqualToAnchor(superview.topAnchor, constant: inset)
        let bottomConstraint:   NSLayoutConstraint = bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor, constant: -inset)
        let leftConstraint:     NSLayoutConstraint = leftAnchor.constraintEqualToAnchor(superview.leftAnchor, constant: inset)
        let rightConstraint:    NSLayoutConstraint = rightAnchor.constraintEqualToAnchor(superview.rightAnchor, constant: -inset)
        
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    // MARK: Centering
    
    /// Constrains the center of the view to the center of its `superview`.
    /// - Note: Does nothing if `self.superview == nil`
    func centerInContainer() {
        centerHorizontallyInContainer()
        centerVerticallyInContainer()
    }
    
    /// Centers the view horizontally within its `superview`.
    /// - Note: Does nothing if `self.superview == nil`
    func centerHorizontallyInContainer() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraintEqualToAnchor(superview.centerXAnchor).active = true
    }
    
    /// Centers the view vertically within its `superview`.
    /// - Note: Does nothing if `self.superview == nil`
    func centerVerticallyInContainer() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraintEqualToAnchor(superview.centerYAnchor).active = true
    }
    
    // MARK: Size
    
    func constrainSize(size: CGSize) {
        constrainWidth(size.width)
        constrainHeight(size.height)
    }
    
    func constrainWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint: NSLayoutConstraint = widthAnchor.constraintEqualToConstant(width)
        widthConstraint.identifier = "width"
        widthConstraint.active = true
    }
    
    func constrainHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint: NSLayoutConstraint = heightAnchor.constraintEqualToConstant(height)
        heightConstraint.identifier = "height"
        heightConstraint.active = true
    }
    
    // Getting Constraints
    
    /// - Returns: The `NSLayoutConstraint` applied to the view where `constraint.identifier == identifier`,
    /// or `nil` if no such constraint exists.
    func constraintWithIdentifier(identifier: String) -> NSLayoutConstraint? {
        for constraint in constraints {
            if constraint.identifier == identifier {
                return constraint
            }
        }
        return nil
    }
}