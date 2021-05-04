include: "/views/users_extended.view"

view: user_with_age_extension {
  extends: [users_extended]
    suggestions: no

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }
}



view: +user_with_age_extension {

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
}
