
Upload file 


```c#
private System.Windows.Forms.WebBrowser webBrowseForPdf;
private System.Windows.Forms.PictureBox uploadPicture;
```

```c#
private void btnUpload_Click(object sender, EventArgs e)
		{

			using (OpenFileDialog openFileDialog = new OpenFileDialog())
			{
				openFileDialog.Filter = "Image Files (*.jpg;*.jpeg;*.png)|*.jpg;*.jpeg;*.png|PDF Files (*.pdf)|*.pdf";
				openFileDialog.Title = "Select a File";

				if (openFileDialog.ShowDialog() == DialogResult.OK)
				{
					string filePath = openFileDialog.FileName;

					// Handle the file (e.g., display image or read PDF)
					if (filePath.EndsWith(".pdf"))
					{
						// Display PDF (You might need a PDF viewer component) 
						webBrowseForPdf.Navigate(filePath);
						webBrowseForPdf.Location = new Point(874, 12);
						webBrowseForPdf.Width = 439;
						webBrowseForPdf.Height = 663;
						webBrowseForPdf.Tag = filePath;
						uploadPicture.Location = new Point(110332, 12);
						//uploadPicture =  new PictureBox();
						uploadPicture.Tag = "";
					}
					else
					{
						uploadPicture.Location = new Point(874, 12);
						// Display image
						uploadPicture.Image = new Bitmap(filePath);
						//uploadPicture.Dock = DockStyle.Fill; 
						uploadPicture.SizeMode = PictureBoxSizeMode.StretchImage;
						uploadPicture.Tag = filePath;
						 webBrowseForPdf.Location = new Point(110233, 12);
						//webBrowseForPdf = new WebBrowser();
						webBrowseForPdf.Tag = "";
					}
				}
			}

		}
```




Download File 

```c#
private void btnDownloadImage()
		{

			string url = "";
			if (webBrowseForPdf !=  null && string.IsNullOrEmpty(webBrowseForPdf.Url.AbsoluteUri))
			{
				url = webBrowseForPdf.Url.LocalPath;
			}
			
			if(uploadPicture != null && string.IsNullOrEmpty(uploadPicture.Tag as string)) { 
				url = uploadPicture.Name;
			}
			using (SaveFileDialog saveFileDialog = new SaveFileDialog())
			{
				saveFileDialog.Filter = "Image Files|*.jpg;*.jpeg;*.png|All Files|*.*";
				saveFileDialog.Title = "Save an Image File";
				if (saveFileDialog.ShowDialog() == DialogResult.OK)
				{
					using (WebClient client = new WebClient())
					{
						try
						{
							client.DownloadFile(url, saveFileDialog.FileName);
							MessageBox.Show("Image downloaded successfully!");
						}
						catch (Exception ex)
						{
							MessageBox.Show("Error: " + ex.Message);
						}
					}
				}
			}
		}
```

