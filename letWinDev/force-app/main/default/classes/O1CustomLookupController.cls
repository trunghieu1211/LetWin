public class O1CustomLookupController {
	@AuraEnabled
    public static string fetchRecords(String objectName, List<string> fields, List<string> searchFields, string condition, string searchInput, boolean isExactly) {
        try {
            string query = 'SELECT ' + String.join(fields, ', ') + ' FROM ' + objectName + ' WHERE Id != null ';
            
            if(isExactly) { 
                query += 'AND Id = :searchInput ';
            }
            else {
                if(condition != null && condition != '') {
                    query += 'AND (' + condition + ') ';
                }
                
                if(searchFields != null) {
                    string searchConditions = '';
                    for(string s : searchFields) {
                        if(searchConditions != '') {
                            searchConditions += 'OR ';
                        }
                        searchConditions += (s + ' LIKE \'%' + searchInput + '%\' ');
                    }
                    query += 'AND (' + searchConditions + ') ';
                }
            }
            
            query += 'LIMIT 10';
            query = query.replace('`', '\'');
            
            List<sObject> lst = Database.query(query);
            //DataHelper.Log('Test1', lst);
            //DataHelper.Log('Test2', Database.getQueryLocator(query));
            return JSON.serialize(lst);
            /*
            for(Contact o : Database.query(query)) {
                if(result != '') {
                    result += ', ';
                }
                string json = '';
                for(string field : fields) {
                    if(json != '') {
                        json += ', ';
                    }
                    //DataHelper.Log('field', field);
                    //DataHelper.Log('field.split().size()', field.contains('.'));
                    
                    if(field.contains('.')) {
                        if(o.getSObject(field.split('\\.')[0]) != null) {
                            json += '"'+field+'": "' + o.getSObject(field.split('\\.')[0]).get(field.split('\\.')[1]) + '"';
                        }
                    }
                    else {
                        json += '"'+field+'": "' + o.get(field) + '"';
                    }
                }
                json = '{' + json + '}';
                result += json;
            }
            result = '[' + result + ']';
            
            //DataHelper.Log('query', query);
            //DataHelper.Log('result', result);*/
        }
        catch(Exception e) {
            DataHelper.Log('O1CustomLookupController.fetchRecords', e.getLineNumber() + ' | ' + e.getMessage());
        }
        return null;
    }
}