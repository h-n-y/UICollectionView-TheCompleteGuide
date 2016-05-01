import UIKit

extension UIView {
    
    // MARK: Edge Constraints 
    
    /// Constrains `self`'s edges to its superview's edges.
    func constrainToEdgesOfContainer() {
        self.constrainToEdgesOfContainerWithInset(0.0)
    }
    
    /// Constrains `self` such that its edges are inset from its `superview`'s edges by `inset`.
    func constrainToEdgesOfContainerWithInset(inset: CGFloat) {
        self.constrainToEdgesOfContainerWithInsets(topBottom: inset, leftRight: inset)
    }
    
    func constrainToEdgesOfContainerWithInsets(topBottom y: CGFloat, leftRight x: CGFloat) {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraintEqualToAnchor(superview.topAnchor, constant: y).active = true
        self.bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor, constant: -y).active = true
        self.leftAnchor.constraintEqualToAnchor(superview.leftAnchor, constant: x).active = true
        self.rightAnchor.constraintEqualToAnchor(superview.rightAnchor, constant: -x).active = true
    }
    
    func constrainLeftEdgeToContainer() {
        constrainLeftEdgeToContainerWithInset(0.0)
    }
    func constrainLeftEdgeToContainerWithInset(inset: CGFloat) {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leftAnchor.constraintEqualToAnchor(superview.leftAnchor, constant: inset).active = true
    }
    
    func constrainTopEdgeToContainer() {
        constrainTopEdgeToContainerWithInset(0.0)
    }
    func constrainTopEdgeToContainerWithInset(inset: CGFloat) {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraintEqualToAnchor(superview.topAnchor, constant: inset).active = true
    }
}