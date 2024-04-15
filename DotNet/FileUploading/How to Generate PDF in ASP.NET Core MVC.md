##### **Install iTextS Package:**

![[word-image-46438-1.webp]]
##### **Create Models**
```C#
namespace FileUploadInMVC.Models
{
    public class Invoice
    {
        public string InvoiceNumber { get; set; }
        public DateTime Date { get; set; }
        public string CustomerName { get; set; }
        public List<InvoiceItem> Items { get; set; }
        public decimal TotalAmount { get; set; }
        public string PaymentMode { get; set; }
    }

    public class InvoiceItem
    {
        public string ItemName { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal TotalPrice => Quantity * UnitPrice;
    }
}
```

##### **Create a PDF Generation Service**

```C#
using iText.Kernel.Pdf;
using iText.Layout.Properties;
using iText.Layout;
using iText.Layout.Element;
using FileUploadInMVC.Models;

namespace FileUploadInMVC.Models
{
    public class PDFService
    {
        public byte[] GeneratePDF(Invoice invoice)
        {
            //Define your memory stream which will temporarily hold the PDF
            using (MemoryStream stream = new MemoryStream())
            {
                //Initialize PDF writer
                PdfWriter writer = new PdfWriter(stream);

                //Initialize PDF document
                PdfDocument pdf = new PdfDocument(writer);

                // Initialize document
                Document document = new Document(pdf);

                // Add content to the document
                // Header
                document.Add(new Paragraph("Invoice")
                    .SetTextAlignment(TextAlignment.CENTER)
                    .SetFontSize(20));

                // Invoice data
                document.Add(new Paragraph($"Invoice Number: {invoice.InvoiceNumber}"));
                document.Add(new Paragraph($"Date: {invoice.Date.ToShortDateString()}"));
                document.Add(new Paragraph($"Customer Name: {invoice.CustomerName}"));
                document.Add(new Paragraph($"Payment Mode: {invoice.PaymentMode}"));

                // Table for invoice items
                Table table = new Table(new float[] { 3, 1, 1, 1 });
                table.SetWidth(UnitValue.CreatePercentValue(100));
                table.AddHeaderCell("Iten Name");
                table.AddHeaderCell("Quantity");
                table.AddHeaderCell("Unit Price");
                table.AddHeaderCell("Total");

                foreach (var item in invoice.Items)
                {
                    table.AddCell(new Cell().Add(new Paragraph(item.ItemName)));
                    table.AddCell(new Cell().Add(new Paragraph(item.Quantity.ToString())));
                    table.AddCell(new Cell().Add(new Paragraph(item.UnitPrice.ToString("C"))));
                    table.AddCell(new Cell().Add(new Paragraph(item.TotalPrice.ToString("C"))));
                }

                //Add the Table to the PDF Document
                document.Add(table);

                // Total Amount
                document.Add(new Paragraph($"Total Amount: {invoice.TotalAmount.ToString("C")}")
                    .SetTextAlignment(TextAlignment.RIGHT));

                // Close the Document
                document.Close();

                return stream.ToArray();
            }
        }
    }
}
```

##### **Create the PDF Generation Action Method**
```C#
//Generate Invoice PDF using iText
public IActionResult GenerateInvoicePDF()
{
    // Sample invoice data
    // Here, we have hardcoded the data,
    // In Real-time you will get the data from the database
    var invoice = new Invoice
    {
        InvoiceNumber = "INV-DOTNET-1001",
        Date = DateTime.Now,
        CustomerName = "Pranaya Rout",
        Items = new List<InvoiceItem>
                {
                    new InvoiceItem { ItemName = "Item 1", Quantity = 2, UnitPrice = 15.0m },
                    new InvoiceItem { ItemName = "Item 2", Quantity = 3, UnitPrice = 10.0m },
                    new InvoiceItem { ItemName = "Item 3", Quantity = 1, UnitPrice = 35.0m }
                },
        PaymentMode = "COD"
    };

    //Set the Total Amount
    invoice.TotalAmount = invoice.Items.Sum(x => x.TotalPrice);

    //Create an Instance of PDFService
    PDFService pdfService = new PDFService();

    //Call the GeneratePDF method passing the Invoice Data
    var pdfFile = pdfService.GeneratePDF(invoice);

    //Return the PDF File
    return File(pdfFile, "application/pdf", "Invoice.pdf");
}
```

