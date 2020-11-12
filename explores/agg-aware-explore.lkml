include: "/views/*.lkml"


view: +order_items {
  measure: total_sales {
    type: sum
    value_format_name: usd
    sql: ${order_items.sale_price} ;;
  }
}


# For Turtles
explore: order_items {
 label: "Sales Totals Turtles"
  query: sales_quarterly {
# group_label: "New Section"
    description: "Description for Info hover"
    label: "Quarterly Sales Totals"
    dimensions: [order_items.created_at_quarter]
    measures: [order_items.total_sales]
    pivots: [order_items.created_at_quarter]
    sorts: [order_items.total_sales: asc]
#     timezone: query_timezone
    filters: [order_items.created_at_year: "2019"]
    limit: 3
  }

  fields: [user_id,
    order_items.sale_price,
    order_items.created_at_date,
    order_items.created_at_time,
    order_items.created_at_week,
    order_items.created_at_month,
    order_items.created_at_quarter,
    order_items.created_at_year,
    order_items.count,
    order_items.total_sales,
    wholesale_value_from_dimension]

}

# Place in `e_thelook` model
explore: +order_items {
  aggregate_table: rollup__sale_price {
    query: {
      dimensions: [sale_price]
      measures: [total_sales]
    }

    materialization: {
      datagroup_trigger: orders_datagroup
    }
  }
}




# For Aggregate Awareness

explore: order_items_aggaware {
  view_name: order_items
  label: "Sales Totals"
  fields: [user_id,
    order_items.sale_price,
    order_items.sale_price,
    order_items.created_at_date,
    order_items.created_at_time,
    order_items.created_at_week,
    order_items.created_at_month,
    order_items.created_at_quarter,
    order_items.created_at_year,
    order_items.count,
    order_items.total_sales]

  join: users {
    sql_on: ${users.id} = ${order_items.id} ;;
    relationship: one_to_many
  }


  aggregate_table: sales_weekly {
    query: {
      dimensions: [order_items.created_at_week]
      measures: [order_items.total_sales]
    }
    materialization: {
      datagroup_trigger: orders_datagroup
    }
  }

  aggregate_table: sales_daily {
    query:  {
      dimensions: [order_items.created_at_date]
      measures: [order_items.total_sales]
    }
    materialization: {
      datagroup_trigger: orders_datagroup
    }
  }


  aggregate_table: sales_monthly {
    materialization: {
      datagroup_trigger: orders_datagroup
    }
    query: {
      dimensions: [order_items.created_at_month]
      measures: [order_items.total_sales]

    }
  }


  aggregate_table: sales_last_weekly {
    query:  {
      dimensions: [order_items.created_at_week]
      measures: [order_items.total_sales]
    }
    materialization: {
      datagroup_trigger: orders_datagroup
    }
  }
}
