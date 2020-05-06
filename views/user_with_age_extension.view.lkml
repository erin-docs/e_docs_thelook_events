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
