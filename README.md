# Multi Query Firestore
Check it out at [Pub.Dev](https://pub.dev/packages/multi_query_firestore)

The best way to create multiple queries in the firestore with various conditions

    MultiQuery(
        list: [
          ref.collection('A').where('count', isGreaterThan: 2),
          ref.collection('B').where('size', isEqualTo: 5),
          ref.collection('C').where('age', isLessThanOrEqualTo: 3)
        ]
    ).snapshots()

## Help Maintenance

I've been maintaining quite many repos these days and burning out slowly. If you could help me cheer up, buying me a cup of coffee will make my life really happy and get much energy out of it.

<a href="https://www.buymeacoffee.com/RtrHv1C" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

## Getting Started

It's simple, just create the object by passing the list of queries as in the example at the beginning.

## Conditions for several

If you want to create a condition or call a class method you can do it like this:

### For all:
   
    MultiQuery(
        list: [
          ref.collection('A'),
          ref.collection('B'),
          ref.collection('C')
        ]
    ).where('age', isLessThanOrEqualTo: 10)
    
### For specifics:

All methods of the parent class `Query` have a copy with the complement *Only* in the name, in these the parameter `indexes` will be requested:

    MultiQuery(
        list: [
          ref.collection('A'), // 0
          ref.collection('B'), // 1
          ref.collection('C')  // 2
        ]
    ).whereOnly(
        field: 'age', 
        // Here you pass the indexes of the queries you want to apply the filter
        indexes: [
            2
        ]
        isLessThanOrEqualTo: 10
    )
    
    