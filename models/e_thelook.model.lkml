connection: "red_look"
include: "/views/products.view"


# include: "//e_redlook/views/product_facts.view"
# explore: product_facts {}


datagroup: e_look_bq_default_datagroup {
  sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}


# include all the views
include: "/views/**/*.view"
include: "/explores/agg-aware-explore.lkml"


#explore: +order_items {}

# explore: order_items {}

# explore: inventory_items {
#   join: products {
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }

include: "/views/products.view"

explore: order_facts {}

explore: distribution_centers {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: orders {
  view_name: orders

  join: order_items {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one


  }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${orders.user_id} ;;
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

  # aggregate_table: rollup__users_state {
  #   query: {
  #     dimensions: [users.state]
  #     measures: [users.count]
  #   }

  #   materialization: {
  #     datagroup_trigger: orders_datagroup
  #   }
  }

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {}


# # Place in `e_thelook` model
# explore: +orders {
#   aggregate_table: rollup__users_state__0 {
#     query: {
#       dimensions: [users.state]
#       measures: [users.count]
#     }

# materialization: {
#   datagroup_trigger: orders_datagroup
# }
# }
# }



# # Place in `e_thelook` model
#   explore: +orders {
#     aggregate_table: rollup__users_state__0 {
#       query: {
#         dimensions: [users.city]
#         measures: [users.count]
#       }

#       materialization: {
#         datagroup_trigger: orders_datagroup
#       }
# }}




# agg_table
explore: order_items {
  join: orders {
    #_each
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: users {
    #_each
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: +order_items {
  aggregate_table: rollup__orders_created_date {
    query: {
      dimensions: [orders.created_date]
      measures: [average_amount]
    }

    materialization: {
      datagroup_trigger: e_look_bq_default_datagroup
    }
  }
}


    explore: users_extended {}
    explore: user_with_age_extension {
    }



    datagroup: orders_datagroup {
      sql_trigger: SELECT MAX(id) FROM etl_log;;
      max_cache_age: "1 hour"
    }

    persist_with: orders_datagroup
