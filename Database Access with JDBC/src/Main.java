import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;


public class Main {
    private static final String CONNECTION_STRING = "jdbc:mysql://localhost:3306/";
    private static final String DATABASE_NAME = "minions_db";
    private static BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
    private static Connection connection;

    public static void main(String[] args) throws SQLException, IOException {
        connection = getConnection();
        System.out.println("Enter exercise number: ");
        int exNumber = Integer.parseInt(reader.readLine());

        switch (exNumber) {
            case 2 -> exTwo();
            case 3 -> exThree();
            case 4 -> exFour();
            case 5 -> exFive();
            case 6 -> exSix();
            case 7 -> exSeven();
            case 8 -> exEight();
            case 9 -> exNine();
        }

    }


    private static void exNine() throws IOException, SQLException {
        System.out.println("Enter minion id: ");
        int minionId = Integer.parseInt(reader.readLine());
        CallableStatement callableStatement = connection.prepareCall("CALL usp_get_older(?) ");
        callableStatement.setInt(1, minionId);
        int effect = callableStatement.executeUpdate();
        PreparedStatement preparedStatement = connection
                .prepareStatement("SELECT name, age FROM minions");
        ResultSet resultSet = preparedStatement.executeQuery();
        while (resultSet.next()){
            System.out.printf("%s %d %n",resultSet.getString("name"), resultSet.getInt("age"));
        }
    }

    private static void exEight() throws IOException, SQLException {
        System.out.println("Enter minion id: ");
        int[] ids = Arrays.stream(reader.readLine().split("\\s+")).mapToInt(Integer::parseInt).toArray();
        PreparedStatement preparedStatement = connection.prepareStatement("UPDATE minions SET name = LOWER(name)" +
                ", age = age + 1  WHERE id = ?;");
        for (int id : ids) {
            preparedStatement.setInt(1, id);
            preparedStatement.executeUpdate();
            preparedStatement = connection.prepareStatement("SELECT name, age FROM minions;");
            ResultSet resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                System.out.println(resultSet.getString("name") + " " + resultSet.getInt("age"));
            }

        }

    }

    private static void exSeven() throws SQLException {
        PreparedStatement preparedStatement = connection
                .prepareStatement("SELECT name FROM minions");

        ResultSet resultSet = preparedStatement.executeQuery();

        List<String> allMinionsNames = new ArrayList<>();

        while (resultSet.next()) {
            allMinionsNames.add(resultSet.getString(1));
        }

        for (int i = 0; i < allMinionsNames.size() / 2; i++) {
            System.out.println(allMinionsNames.get(i));
            System.out.println(allMinionsNames.get(allMinionsNames.size() - 1 - i));

        }
    }

    private static void exSix() throws IOException, SQLException {
        System.out.println("Enter villain id: ");
        int villainId = Integer.parseInt(reader.readLine());

        int affectedEntities = deleteMinionsByVillainId(villainId);
        String villainName= findEntityNameById("villains" ,villainId);
        if(villainName == null){
            System.out.println("No such villain was found");
        } else {
            deleteVillainById(villainId);
            System.out.printf("%s was deleted%n" + "%d minions released%n", villainName, affectedEntities);

        }
    }

    private static void deleteVillainById(int villainId) throws SQLException {
        PreparedStatement preparedStatement = connection
                .prepareStatement("DELETE FROM villains WHERE id  = ?");
        preparedStatement.setInt(1,villainId);


    }

    private static int deleteMinionsByVillainId(int villainId) throws SQLException {
        PreparedStatement preparedStatement = connection
                .prepareStatement("DELETE FROM minions_villains WHERE villain_id = ?");

        preparedStatement.setInt(1,villainId);
        return preparedStatement.executeUpdate();
    }

    private static void exFive() throws IOException, SQLException {
        System.out.println("Enter country name: ");
        String countryName = reader.readLine();
        PreparedStatement preparedStatement = connection.prepareStatement("UPDATE towns SET name = UPPER(name) WHERE country = ?");
        preparedStatement.setString(1, countryName);

        int affectedRows = preparedStatement.executeUpdate();
        if (affectedRows == 0) {
            System.out.println("No town names were affected.");
            return;
        }
        System.out.printf("%d town names were affected.%n", affectedRows);
        PreparedStatement preparedStatementTowns = connection.prepareStatement("SELECT name FROM towns WHERE country = ?");
        preparedStatementTowns.setString(1, countryName);

        ResultSet resultSet = preparedStatementTowns.executeQuery();
        while (resultSet.next()) {
            System.out.println(resultSet.getString("name"));
        }
    }

    private static void exFour() throws IOException, SQLException {
        System.out.println("Enter data for minion and villain: ");
        String[] minions = reader.readLine().split("\\s+");
        String[] villains = reader.readLine().split("\\s+");
        insertInfoForMinions(minions);
        insertInfoForVillains(villains);
        System.out.printf("Successfully added %s to be minion of %s.", minions[1], villains[1]);
    }

    private static void insertInfoForMinions(String[] minionData) throws SQLException {
        String minionName = minionData[1];
        int age = Integer.parseInt(minionData[2]);
        String townName = minionData[3];
        int townId;
        int minionId;
        ResultSet resultTownId = checkForExistingEntity("towns", townName);
        if (!resultTownId.isBeforeFirst()) {
            insertIntoTable("towns", townName);
            System.out.printf("Town %s was added to the database.%n", townName);
            ResultSet resultTownAfterInsert = checkForExistingEntity("towns", townName);
            resultTownAfterInsert.next();
            townId = resultTownAfterInsert.getInt("id");
        } else {
            resultTownId.next();
            townId = resultTownId.getInt("id");
        }
        ResultSet resultMinion = checkForExistingEntity("minions", minionName);
        if (!resultMinion.isBeforeFirst()) {
            insertIntoMinionTable(minionName, age, townId);
            ResultSet resultAfterMinionInsert = checkForExistingEntity("minions", minionName);
            resultAfterMinionInsert.next();
            minionId = resultAfterMinionInsert.getInt("id");
        } else {
            minionId = resultMinion.getInt("id");
            PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO minions_villains (minion_id) " +
                    "VALUE (?);");
            preparedStatement.setInt(1, minionId);
            preparedStatement.executeUpdate();
        }
    }

    private static void insertIntoMinionTable(String minionName, int age, int townId) throws SQLException {
        String query = String.format("INSERT INTO minions (name, age, town_id) " + "VALUES ('%s', %d, %d);", minionName, age, townId);
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.executeUpdate();
    }

    private static void insertInfoForVillains(String[] villainData) throws SQLException {
        String villainName = villainData[1];
        int villainId;
        ResultSet rsVillain = checkForExistingEntity("villains", villainName);
        if (!rsVillain.isBeforeFirst()) {
            insertIntoTable("villains", villainName);
            ResultSet villainAfterInsert = checkForExistingEntity("villains", villainName);
            villainAfterInsert.next();
            villainId = villainAfterInsert.getInt("id");
            PreparedStatement preparedStatementEvil = connection.prepareStatement("UPDATE villains SET evilness_factor = 'evil' WHERE id = ?");
            preparedStatementEvil.setInt(1, villainId);
            preparedStatementEvil.executeUpdate();
            System.out.printf("Villain %s was added to the database.%n", villainName);
        } else {
            rsVillain.next();
            villainId = rsVillain.getInt("id");
        }
        PreparedStatement preparedStatement = connection.prepareStatement("UPDATE minions_villains " +
                "SET villain_id = ? " + "WHERE villain_id IS NULL ;");
        preparedStatement.setInt(1, villainId);
    }

    private static void insertIntoTable(String tableName, String name) throws SQLException {
        String query = String.format("INSERT INTO %s (name) VALUE ('%s');", tableName, name);
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.executeUpdate();
    }

    private static ResultSet checkForExistingEntity(String tableName, String name) throws SQLException {
        String query = String.format("SELECT id FROM %s WHERE name = '%s'", tableName, name);
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        return preparedStatement.executeQuery();
    }

    private static void exThree() throws IOException, SQLException {
        System.out.println("Enter villain id: ");
        int villain_id = Integer.parseInt(reader.readLine());
        //  String villainName = findVillainNameById(villain_id);
        String villainName = findEntityNameById("villains", villain_id);

        PreparedStatement preparedStatement = connection.prepareStatement("SELECT m.name, m.age FROM minions m " +
                "join minions_villains mv on m.id = mv.minion_id " +
                "WHERE mv.villain_id = ?;");
        preparedStatement.setInt(1, villain_id);
        ResultSet resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
            System.out.println("Villain: " + villainName);
            int counter = 0;
            while (resultSet.next()) {
                System.out.printf("%d. %s %d%n", ++counter,
                        resultSet.getString("name"),
                        resultSet.getInt("age")
                );
            }
        } else {
            System.out.printf("No villain with ID %d exists in the database.", villain_id);
        }

    }

    private static String findEntityNameById(String tableName, int entityId) throws SQLException {
        String query = String.format("SELECT name FROM %s WHERE id = ?", tableName);
        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setInt(1, entityId);
        ResultSet resultSet = preparedStatement.executeQuery();
        return resultSet.next() ? resultSet.getString(1) : null;
    }

    private static String findVillainNameById(int villainId) throws SQLException {
        PreparedStatement preparedStatement = connection.prepareStatement("SELECT name FROM villains WHERE id = ?");
        preparedStatement.setInt(1, villainId);
        ResultSet resultSet = preparedStatement.executeQuery();

        resultSet.next();
        return resultSet.getString("name");

    }

    private static void exTwo() throws SQLException {
        PreparedStatement preparedStatement = connection
                .prepareStatement("SELECT v.name, COUNT(DISTINCT mv.minion_id) AS `m_count` FROM villains v " +
                        "JOIN minions_villains mv on v.id = mv.villain_id " +
                        "GROUP BY v.name " +
                        "HAVING `m_count` > ?; ");
        preparedStatement.setInt(1, 15);

        ResultSet resultSet = preparedStatement.executeQuery();
        while (resultSet.next()) {
            System.out.printf("%s %d %n", resultSet.getString(1), resultSet.getInt(2));
        }
    }

    private static Connection getConnection() throws IOException, SQLException {
        System.out.println("Enter user:");
        String user = reader.readLine();
        user = user.equals("") ? "root" : user;
        System.out.println("Enter password:");
        String password = reader.readLine();
        password = password.equals("") ? "root" : password;
        Properties properties = new Properties();
        properties.setProperty("user", user);
        properties.setProperty("password", password);
        return DriverManager
                .getConnection(CONNECTION_STRING + DATABASE_NAME, properties);

    }
}
