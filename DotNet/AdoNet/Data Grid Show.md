
```C#
	// Show data in Grid uning  Spasific Data List or Array 
	    private void FillGridRequestion(List<KitchneRequestion> kitchenRequsition)
        {
         
            dgRequistions.SuspendLayout();
            dgRequistions.Rows.Clear();
            foreach (var item in kitchenRequsition)
            {
                DataGridViewRow row = new DataGridViewRow();
                row.Tag = item;
                row.CreateCells (
	                dgRequisition, 
	                item.RequisitionId,
	                item.RequsitionDate,
	                item.Status
                );
                dgRequistions.Rows.Add(row);
            }
        }
```
