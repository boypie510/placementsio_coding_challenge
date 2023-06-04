require 'tempfile'
require 'csv'

# Generate line_items invoice for specific campaign
class InvoiceGenerator
  def initialize(line_items)
    @line_items = line_items
  end

  def execute(type, &block)
    case type.to_sym
    when :csv
      generate_and_send_csv(&block)
    when :xlsx
      generate_and_send_xlsx(&block)
    else
      raise ArgumentError, "Invalid file type: #{type}"
    end
  end

  private

  def generate_and_send_csv
    Tempfile.create(['campaign_invoice_export', '.csv']) do |tempfile|
      generate_invoice_csv(tempfile.path)
      yield File.read(tempfile.path), 'campaign_invoice_export.csv', Mime[:csv].to_s
    end
  end

  def generate_and_send_xlsx
    Tempfile.create(['campaign_invoice_export', '.xlsx']) do |tempfile|
      generate_invoice_xlsx(tempfile.path)
      yield File.read(tempfile.path), 'campaign_invoice_export.xlsx', Mime[:xlsx].to_s
    end
  end

  def generate_invoice_csv(file_path)
    CSV.open(file_path, 'w') do |csv|
      csv << ['Name', 'Booked Amount', 'Actual Amount', 'Adjustments', 'Billable Amount']

      @line_items.each do |line_item|
        csv << [line_item.name, line_item.booked_amount, line_item.actual_amount, line_item.adjustments, line_item.billable_amount]
      end
    end
  end

  def generate_invoice_xlsx(file_path)
    workbook = Spreadsheet::Workbook.new
    worksheet = workbook.create_worksheet(name: 'Invoice')

    worksheet.row(0).concat(['Name', 'Booked Amount', 'Actual Amount', 'Adjustments', 'Billable Amount'])

    @line_items.each_with_index do |line_item, index|
      worksheet.row(index + 1).concat([line_item.name, line_item.booked_amount, line_item.actual_amount, line_item.adjustments, line_item.billable_amount])
    end

    workbook.write(file_path)
  end

  def send_tempfile(file_data, file_name, content_type)
    send_data file_data, filename: file_name, type: content_type, disposition: 'attachment'
  end
end
