view: order_items {
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created_at {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }


  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    label: "okrrrrr"
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  dimension: amount_sale_price {
    sql: (${TABLE}.sale_price) ;;
  }

  measure: wholesale_value_measure {
    type: number
    sql: (${sale_price} * 0.60) ;;
  }


  dimension: total_sale_price {
    sql: (${TABLE}.total_sale_price) ;;
  }

  measure: wholesale_value_from_dimension{
    type: number
    sql: (${total_sale_price} * 0.60) ;;
  }


  dimension: amount_dimension {
    sql: (${TABLE}.amount) ;;
  }

  measure: average_amount {
    type: average
    sql: ${TABLE}.amount ;;
  }

  measure: average_amount_from_dimension {
    type: average
    sql: ${amount_dimension} ;;
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
