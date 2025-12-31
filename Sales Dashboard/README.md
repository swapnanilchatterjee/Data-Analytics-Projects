# Sales Dashboard

## Overview
This project features a Power BI dashboard (`My First Dashboard.pbix`) designed to analyze and visualize sales performance.

## Files
- **My First Dashboard.pbix**: The main Power BI report file.
- **customers.csv**: Dataset containing customer details.
- **orders.csv**: Dataset containing order transactions.

## Data Dictionary

### customers.csv
| Column | Description |
|--------|-------------|
| `customer_id` | Unique identifier for the customer |
| `first_name` | Customer's first name |
| `last_name` | Customer's last name |
| `country` | Country of residence |
| `state` | State of residence |
| `city` | City of residence |
| `score` | Customer score |

### orders.csv
| Column | Description |
|--------|-------------|
| `order_id` | Unique identifier for the order |
| `order_date` | Date of the order |
| `customer_id` | Foreign key linking to the customer |
| `product_name` | Name of the product sold |
| `product_category` | Category of the product |
| `quantity` | Number of units sold |
| `sales` | Total sales amount |

## Usage
1. Open `My First Dashboard.pbix` in Microsoft Power BI Desktop.
2. Refresh the data if necessary to load the latest records from the CSV files.
