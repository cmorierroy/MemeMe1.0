//
//  MemeEditorViewExtensions.swift
//  MemeMe1.0
//
//  Created by Cédric Morier-Roy on 2020-10-02.
//

import Foundation
import UIKit

extension MemeEditorView : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: {() in self.enableShare(true)})
    }
}

extension MemeEditorView : UITextFieldDelegate
{
    //MARK: UITextfield Delegate methods
    //Clear text field when the user starts typing (only the first time around)
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.text == defaultTopText && !topDefaultErased
        {
            textField.text = ""
            topDefaultErased = true
        }
        else if textField.text == defaultBottomText && !bottomDefaultErased
        {
            textField.text = ""
            bottomDefaultErased = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}
