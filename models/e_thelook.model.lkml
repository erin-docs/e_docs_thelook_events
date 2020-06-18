connection: "thelook_events"

include: "/explores/agg-aware-explore.lkml"

explore: users_extended {}
explore: user_with_age_extension {
}


# include all the views
include: "/views/**/*.view"

datagroup: orders_datagroup {
  sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: orders_datagroup

explore: distribution_centers {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: orders {
  view_name: order_items
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  aggregate_table: rollup__users_state {
    query: {
      dimensions: [users.state]
      measures: [users.count]
    }

    materialization: {
      datagroup_trigger: orders_datagroup
    }
  }

}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {}





# explore: +orders {
#   aggregate_table: rollup__users_state__0 {
#     query: {
#       dimensions: [users.state]
#       measures: [users.count]
#     }
#
#     materialization: {
#       datagroup_trigger: orders_datagroup
#     }
#   }
#
#   aggregate_table: rollup__order_items_created_date__products_category__1 {
#     query: {
#       dimensions: [order_items.created_date, products.category]
#       measures: [order_items.count]
#       filters: [
#         order_items.created_date: "7 weeks",
#         products.category: "Accessories,Blazers & Jackets,Fashion Hoodies & Sweatshirts,Shorts,Sweaters,Skirts"
#       ]
#       timezone: "America/Los_Angeles"
#     }
#
#     materialization: {
#       datagroup_trigger: orders_datagroup
#     }
#   }
# }
