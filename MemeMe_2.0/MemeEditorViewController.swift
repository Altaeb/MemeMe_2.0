//
//  MemeEditorViewController.swift
//  MemeMe_2.0
//
//  Created by Abdalfattah Altaeb on 4/10/20.
//  Copyright © 2020 Abdalfattah Altaeb. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    //MARK: IBoutlets

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!

    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!

    @IBOutlet weak var shareButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareTextField(textField: topText, defaultText:"TOP")
        prepareTextField(textField: bottomText, defaultText:"BOTTOM")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topText.clearsOnBeginEditing = true
        bottomText.clearsOnBeginEditing = true
        shareButton.isEnabled = imagePickerView.image != nil

    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if(bottomText.isEditing){
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }


    func prepareTextField(textField: UITextField, defaultText: String) {
        textField.delegate = self
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.borderStyle = .none
    }

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "impact", size: 40)!,
        .strokeWidth:  -1.2
    ]

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }



    // MARK: UIImagePickerController Functions

    @IBAction func pickAnImage(_ sender: Any) {
        //To pick an image from Photos Albums
        pickImage(sourceType: .photoLibrary)
    }

    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        // To take a image directly from camera
        pickImage(sourceType: .camera)
    }

    // MARK: UIImagePickerController Delegates

    func pickImage(sourceType: UIImagePickerController.SourceType){
        shareButton.isEnabled = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // To select an image and set it to imageView
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // To dismiss imagePicker when cancel button is clicked
        dismiss(animated: true, completion: nil)

    }
    
    // Create a meme object and save it to the memes array
    func save(memedImage: UIImage) {
        // Update the meme
        let meme = Meme(top: topText.text!, bottom: bottomText.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        // Add it to the meme array on the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }

    // MARK: Generate Meme Image

    func generateMemedImage() -> UIImage {
        //  Hide toolbar and navbar
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true

        // Create a UIImage that combines the Image View and the Textfields
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        //  Show toolbar and navbar
        topToolBar.isHidden = false
        bottomToolBar.isHidden = false

        return memedImage
    }

    //MARK: Top Bar Button Actions

    @IBAction func shareButton(_ sender: Any) {
        let memeGen = generateMemedImage()

        let activityViewController = UIActivityViewController(activityItems: [memeGen], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                //save the image
                self.save(memedImage: memeGen)
                self.dismiss(animated: true, completion: nil)

                //Unwind to SentMemeTableView
                self.performSegue(withIdentifier:"showMeme", sender: nil)
            }
        }
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func cancelAction(_ sender: AnyObject) {

                   let alert = UIAlertController(title:"Discard" , message:"Are you sure you want to discard your changes?", preferredStyle: .actionSheet)

                   let clear = UIAlertAction(title: "Clear Meme Editor", style: .destructive) { (UIAlertAction) in

                       self.imagePickerView.image = nil
                    self.prepareTextField(textField: self.topText, defaultText:"TOP")
                    self.prepareTextField(textField: self.bottomText, defaultText:"BOTTOM")
                       self.shareButton.isEnabled = false
                   }

                   let dismiss = UIAlertAction(title: "Dismiss Meme Editor", style: .destructive, handler: { (UIAlertAction) in

                       self.dismiss(animated: true, completion: nil)
                       //Unwind to SentMemeTableView
                       self.performSegue(withIdentifier:"showMeme", sender: nil)
                   })

                   let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)


                   alert.addAction(clear)
                   alert.addAction(dismiss)
                   alert.addAction(cancel)

                   self.present(alert, animated: true, completion: nil)
           }
}
